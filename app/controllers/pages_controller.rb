class PagesController < ApplicationController
  def home
    # remember where to come back to in case a post gets deleted
    store_location
    @title = "Home"
    if signed_in?
      @micropost = Micropost.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About Us"
  end

  def help
    @title = "Help"
  end
end
