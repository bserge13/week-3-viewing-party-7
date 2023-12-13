class ViewingPartiesController < ApplicationController 
  def new
    @user = User.find(params[:user_id])
    @movie = Movie.find(params[:movie_id])
  end 
  
  def create 
    if current_user
      user = User.find(params[:user_id])
      user.viewing_parties.create(viewing_party_params)
      redirect_to "/users/#{params[:user_id]}"
    else 
      redirect_to movie_path(user, movie)
      flash[:error] = 'You must be logged in or registered to create a movie party'
    end 
  end 

  private 

  def viewing_party_params 
    params.permit(:movie_id, :duration, :date, :time)
  end 
end 