class MicropostsController < ApplicationController
  before_filter :authenticate,    :only => [:create, :destroy]
  before_filter :authorised_user, :only => :destroy
  before_filter :valid_user,      :only => :index

  def index
    # remember where to come back to in case a post gets deleted
    store_location
    @microposts = @user.microposts
    @title = "All microposts by #{@user.name}"
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to(root_path)
     else
      @feed_items = current_user.feed.paginate(:page => params[:page])
      render 'pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end

  private

    def authorised_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end

    def valid_user
      @user = User.find_by_id(params[:user_id])
      redirect_to root_path if @user.nil?
    end
end
