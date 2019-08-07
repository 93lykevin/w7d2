# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :session_token, presence: true
    validates :password, length: {minimum: 6}, allow_nil: true

    attr_reader :password
    after_initialize :ensure_session_token

    #User.generate_session_token
    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    #find the user by email
    #return nil unless a user is found
    #check if the user's password_digest in the db matches w the supplied password
    #return the user if the passwords match, return nil otherwise
    def self.find_by_credentials(email, password)
        user = User.find_by(email: email)
        return nil unless user
        user.is_password?(password) ? user : nil
    end

    #user1.ensure_session_token
    def ensure_session_token
        #checks to see if user has a session token, if not, generate the user a new one
        self.session_token ||= SecureRandom::urlsafe_base64(16)
    end

    #user1.reset_session_token!
    def reset_session_token!
        #reset the user's session token and save it to the db.
        self.session_token = SecureRandom::urlsafe_base64(16)
        self.save
        self.session_token
    end
    
    #user1.password = "fatcat" should generate a new bcrypted password for "fatcat"
    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    #user1.is_password?("fatcat") => true
    #takes our user's password digest, 
    #creates a new BCrypt::Password object from it
    #then calls the BCrypt's .is_password?() on it and checks it 
    #against the password we've provided
    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end


end
