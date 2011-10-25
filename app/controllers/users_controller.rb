class UsersController < ApplicationController
  before_filter :authenticate,  :only => [ :index, :edit, :update, :destroy ]
  before_filter :correct_user,  :only => [ :edit, :update ]
  before_filter :admin_user,    :only => :destroy
  before_filter :not_signed_in, :only => [ :new, :create ]

  def index
    @users = User.paginate(:page => params[:page])
    @title = 'All users'
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = 'Sign up'
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in(@user)
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = 'Sign up'
      # Make sure the password fields are clear after failure
      @user.password = ''
      @user.password_confirmation = ''
      render :new
    end
  end

  def edit
    @title = 'Edit user'
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "User updated"
      redirect_to @user
    else
      @title = 'Edit user'
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if not current_user?(user)
      user.destroy
      flash[:success] = "User destroyed"
    else
      flash[:error] = "You can't delete yourself"
    end
    redirect_to(users_path)
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def not_signed_in
      redirect_to(root_path) unless not signed_in?
    end
end
