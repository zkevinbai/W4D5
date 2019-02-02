class ApplicationController < ActionController::Base

    def log_in!(user)
        session[:session_token] = user.session_token
    end
end
