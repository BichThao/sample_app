class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_followed, only: :create
  before_action :find_following, only: :destroy

  def index
    @title = params[:relationship]
    @user = User.find_by id:params[:id]
    unless @user
      flash[:danger] = "User not exit"
      redirect_to users_path
    end
    @users = @user.send(@title).paginate page: params[:page]
  end

  def create
    current_user.follow @user
    relationship @user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  def destroy
    current_user.unfollow @user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  private
  def relationship user
    @relationship = current_user.active_relationships.find_by followed_id: user.id
  end

  def find_followed
    User.find_by id: params[:followed_id]
    unless @user
      flash[:danger] = "followed id not exit"
      redirect_to users_path
    end
  end

  def find_following
    @relationship = Relationship.find_by id: params[:id]
    if @relationship
      @user = @relationship.followed
    else
      flash[:danger] = "Relationship not exist"
      redirect_to users_path
    end
  end
end
