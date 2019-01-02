class ReservationsController < ApplicationController
    before_action :authenticate_user! 
    
    def create
        room = Room.find(params[:room_id])
        
        
        if current_user == room.user
            flash[:alert] = "You cannot book your own property!"
        else
            
            start_time = Date.parse(reservation_params[:start_time])
            end_date = Date.parse(reservation_params[:end_date])
            days = (end_date - start_time).to_i + 1
        
            @reservation = current_user.reservations.build(reservation_params)
            @reservation.room = room
            @reservation.price = room.price
            @reservation.total = room.price * days
            @reservation.save
        
            flash[:notice] = "Booked Successfully!"
        end
         redirect_to room
    end
    
    def your_trips
        @trips = current_user.reservations.order(start_time: :asc)
    end
    
    def your_reservations
        @rooms = current_user.rooms
    end

    private
        def reservation_params
            params.require(:reservation).permit(:start_time, :end_date)
        end

end
