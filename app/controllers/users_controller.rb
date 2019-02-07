class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:show]
    
    def show
        @user = User.find(params[:id])
        @rooms = @user.rooms
        
        #Display all the guest reviews to host (if this host is a host)
        @guest_reviews = Review.where(type: "GuestReview", host_id: @user.id)
        
        #Display all the host reviews to host (if this host is a host)
        @host_reviews = Review.where(type: "HostReview", guest_id: @user.id)
    end
    
    def payment
        
    end
    
    def add_card
        if current_user.stripe_id.blank?
            customer = Stripe::Customer.create(
                email: current_user.email
            )
            current_user.stripe_id = customer.id
            current_user.save
        else
            customer = Stripe::Customer.retrieve(current_user.stripe_id)
        end
        
        month, year = params[:expiry].split(/ \/ /)
        new_token = Stripe::Token.create(:card => {
            :number => params[:number],
            :exp_month => month,
            :exp_year => year,
            :cvc => params[:cvv] 
        })
        customer.sources.create(source: new_token.id)
        
        flash[:notice] = "Your card is saved."
        redirect_to payment_method_path
    rescue Stripe::CardError => e
        flash[:alert] = e.message
        redirect_to payment_method_path
    end
    
end
