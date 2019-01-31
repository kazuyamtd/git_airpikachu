class ReservationsController < ApplicationController
    before_action :authenticate_user! 
    before_action :set_reservations, only: [:approve, :decline]
    
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
            # @reservation.save
            
            if @reservation.save
                if room.Request?
                    flash[:notice] = "Request sent successfully!"
                else
                    @reservation.Approved! 
                    flash[:notice] = "Reservation created successfully!"
                end
            else
                flash[:alert] = "Cannot make a reservation!"
            end
        
        end
         redirect_to room
    end
    
    def your_trips
        @trips = current_user.reservations.order(start_time: :asc)
    end
    
    def your_reservations
        @rooms = current_user.rooms
    end

    def approve
        @reservation.Approved!
        redirect_to your_reservations_path
    end
    
    def decline
        @reservation.Declined!
        redirect_to your_reservations_path
    end

    private
        
        def set_reservations
            @reservation = Reservation.find(params[:id])
        end
    
        def reservation_params
            params.require(:reservation).permit(:start_time, :end_date)
        end

end
