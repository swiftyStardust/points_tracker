require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "point_tracker_project"

  end

  get "/" do
    if logged_in?
      @user = current_user

      redirect "/users/#{@user.slug}"
    else
      erb :index
    end
  end

  get "/access-error" do
    erb :"/access-error"
  end

  helpers do 
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def logged_out_redirection
      if !logged_in?
        redirect "/login"
      end
    end

    def sorted_horseshows
      current_user.horseshows.order(:date).uniq
    end
  end
end
