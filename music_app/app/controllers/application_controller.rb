class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?
    
    
    private
    def login_user!(user)
        session[:session_token] = user.reset_session_token!
    end

    #find the current user. return nil unless there is a session token
    #return the current user if the user has been already found OR 
    #find and return the user by searing the DB with the session token
    def current_user
        return nil unless session[:session_token]
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def logged_in?
        !!current_user
    end
    
    #reset session tokens on client & db side(users table)
    #1) do this buy calling reset_session_token! on the user which randomizes
    #the user's session token. => makes it diff from session[:session_token]
    #2) set the session[:session_token] to nil
    #3) set the @current_user to nil
    def logout!
        current_user.reset_session_token!
        session[:session_token] = nil
        @current_user = nil
    end

end
