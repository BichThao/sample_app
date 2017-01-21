class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :find_user, except: [:new, :index, :create]
  before_action :admin_user, only: :destroy

  def show
    @microposts = @user.microposts.recent_posts.paginate page: params[:page]
  end

  def index
    @users = User.activated_users.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render :new
    end
  end
 
  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      flash[:danger] = "Update Failed"
      render :edit
    end
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def destroy
    @user.destroy
    flash[:success] = "Deleted User"
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :picture
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:warning] = "Couldn't find this user. Please try again!"
      redirect_to users_url
    end
  end
end
