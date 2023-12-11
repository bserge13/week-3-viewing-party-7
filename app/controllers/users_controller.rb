class UsersController <ApplicationController 
  def new 
    @user = User.new()
  end 

  def show 
    @user = User.find(params[:id])
  end 

  def create 
    if params[:user][:password] == params[:user][:password_confirmation]
      user = User.create(user_params)
      if user.save
        session[:user_id] = user.id 
        redirect_to user_path(user)
      else  
        flash[:error] = user.errors.full_messages.to_sentence
        redirect_to register_path
      end
    else 
      flash[:error] = "Password and password confirmation do not match."
      redirect_to register_path
    end 
  end 

  private 

  def user_params 
    params.require(:user).permit(:name, :email, :password) 
  end 
end 