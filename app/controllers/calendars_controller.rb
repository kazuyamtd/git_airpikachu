class CalendarsController < ApplicationController
    before_action :authenticate_user!
    
    def host
        @rooms = current_user.rooms
        
        params[:start_time] ||= Date.current.to_s
        params[:room_id] ||= @rooms[0] ? @rooms[0].id : nil
        
        if params[:room_id]
            @room = Room.find(params[:room_id])
            start_time = Date.parse(params[:start_time])
            
            first_of_month = (start_time - 1.months).beginning_of_month
            end_of_month = (start_time + 1.months).end_of_month
            
            @events = @room.reservations.joins(:user).select('reservations.*, users.fullname, users.image, users.email, users.uid')
                      .where('(start_time BETWEEN ? AND ?) AND status <> ?', first_of_month, end_of_month, 2)
        else
            @room = nil
            @events = []
        end
        
    end
    
        
end
