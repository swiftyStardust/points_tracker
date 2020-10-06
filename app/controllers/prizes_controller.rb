class PrizesController < ApplicationController
    get '/prizes/new' do
        logged_out_redirection
        @user = current_user
        
        erb :"/prizes/new"        
    end

    get '/prizes' do
        logged_out_redirection
        @user = current_user

        erb :"/prizes/index"
    end

    post '/prizes' do
        logged_out_redirection #is this necessary???
        @user = current_user
        if prize_valid?(params)
            @horse = Horse.find(params[:horse_id])
            @horseshow = Horseshow.find_or_create_by(params[:horseshow])
        
            @prize = Prize.create(point_total: params[:point_total], horse_id: @horse.id, horseshow_id: @horseshow.id, user_id: @horse.user_id)
        
            redirect "/users/#{@user.slug}"
        else
            redirect "/prizes/invalid-input"
        end
    end

    get '/prizes/:id' do
        logged_out_redirection
        @prize = Prize.find(params[:id])
        
        if @prize.user_id == current_user.id

            erb :"/prizes/show"
        else
            erb :"/access-error"
        end
    end

    get '/prizes/:id/edit' do
        logged_out_redirection
        @prize = Prize.find(params[:id])
        if @prize.user_id == current_user.id

            erb :"/prizes/edit"
        else
            redirect "/access-error"
        end
    end

    patch '/prizes/:id' do
        logged_out_redirection #is this necessary??
        @prize = Prize.find(params[:id])

        if prize_valid?(params)
            @horseshow = Horseshow.find_or_create_by(params[:horseshow])
            @horse = Horse.find(params[:horse_id])
            @prize.update(point_total: params[:point_total], horseshow_id: @horseshow.id, horse_id: @horse.id, user_id: current_user.id)

            redirect "/prizes/#{@prize.id}"
        else
            redirect "/prizes/invalid-input"
        end
    end

    delete '/prizes/:id' do
        logged_out_redirection # is this necessary
        prize = Prize.find(params[:id])
        prize.destroy

        redirect to "/prizes"
    end

    helpers do
    
        def prize_valid?(params)
            return params[:horse_id] != nil && !params[:horseshow][:name].empty? && !params[:horseshow][:location].empty? && params[:point_total].to_i > 0
        end
    end
end