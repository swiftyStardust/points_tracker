class PrizesController < ApplicationController
    get '/prizes/new' do
        @user = User.find(session[:user_id])

        erb :"/prizes/new"
    end

    get '/prizes' do
        @user = User.find(session[:user_id])

        erb :"/prizes/index"
    end

    post '/prizes' do
        @horse = Horse.find(params[:horse_id])
        @horseshow = Horseshow.find_or_create_by(params[:horseshow])
        
        @prize = Prize.create(point_total: params[:point_total], horse_id: @horse.id, horseshow_id: @horseshow.id, user_id: @horse.user_id)
        
        redirect "/account"
    end

    get '/prizes/:id' do
        @prize = Prize.find(params[:id])

        erb :"/prizes/show"
    end

    get '/prizes/:id/edit' do
        @prize = Prize.find(params[:id])
        @user = User.find(session[:user_id])

        erb :"/prizes/edit"
    end

    patch '/prizes/:id' do
        @user = User.find(session[:user_id])
        @prize = Prize.find(params[:id])
        @horseshow = Horseshow.find_or_create_by(params[:horseshow])
        @horse = Horse.find(params[:horse_id])
        @prize.update!(point_total: params[:point_total], horseshow_id: @horseshow.id, horse_id: @horse.id, user_id: @user.id)

        redirect "/prizes"
    end

    delete '/prizes/:id' do
        prize = Prize.find(params[:id])
        prize.destroy

        redirect to "/prizes"
    end
end