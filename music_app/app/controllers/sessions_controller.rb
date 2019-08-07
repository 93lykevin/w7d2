class SessionsController < ApplicationController
    #renders the new login session
    def new
        @user = User.new
        render :new
    end

    #create the new session by
    #1 find the user w/ the right credentials
    #2 log the user in
    def create
        @user = User.find_by_credentials(
            params[:user][:email],
            params[:user][:password] 
        )
    
        if @user.nil?
            flash.now[:errors] = ["Incorrect email and/or password"]
            render :new
        else
            login_user!(@user)
            redirect_to user_url(@user)
        end
    end

    #delete the session tokens for both parties
    def destroy
        logout!
        redirect_to new_session_url
    end
end
