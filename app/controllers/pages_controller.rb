class PagesController < ApplicationController
  def home
    @rooms = Room.where(active: true).limit(3)
  end
  
  def search
    if params[:search].present? && params[:search].strip != ""
      session[:loc_search] = params[:search]
    end
  
    
    if session[:loc_search] && session[:loc_search] != ""
      @rooms_address = Room.where(active: true).near(session[:loc_search], 5, order: 'distance')
    else
      @rooms_address = Room.where(active: true).all
    end
    
    @search = @room_address.ransack(params[:q])
    @rooms = @search.result
    
    @arrRooms = @rooms.to_a
    
    if (params[:start_time] && params[:end_date] && !params[:start_time].empty? && !params[:end_date].empty?)
      
      start_time = Date.parse(params[:start_time])
      end_date = Date.parse(params[:end_date])
      
      @room.each do |room|
        
        not_available = room.reservation.where(
            "(? <= start_time and start_time <= ?)
            OR (? <= end_date and end_date <= ?)
            OR (start_time < ? AND end_date)",
            start_time, end_date, 
            start_time, end_date, 
            start_time, end_date
          ).limt(1)
          
          if not_available.length > 0
            @arrRooms.delete(room)
          end
      end
    end
    
  end
end
