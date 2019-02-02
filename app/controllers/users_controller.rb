class UsersController < ApplicationController

    def index
        render :index
    end 

    def create
        user = User.new(user_params)
        if user.save
            log_in!(user)
            redirect_to users_url
        else
            flash[:error] = "password is too short"
            redirect_to new_user_url    
        end

    end 

    def new
        render :new
    end 
    
    def show
        
    end 

    def update

    end 

    def destroy

    end 

    private
    def user_params
        params.require(:user).permit(:username, :password)
    end

end
