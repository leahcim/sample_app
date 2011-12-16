require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App | "
  end

  describe "GET 'home'" do

    describe "when not signed in" do

      before(:each) do
        get :home
      end

      it "should be successful" do
        response.should be_success
      end

      it "should have the right title" do
        response.should have_selector("title",
                                      :content => @base_title + "Home")
      end
    end

    describe "when signed in" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should have the right follower/following counts" do
        follower = Factory(:user, :email => Factory.next(:email))
        follower.follow!(@user)
        get :home
        response.should have_selector('a', :href => following_user_path(@user),
                                      :content => "0 following")
        response.should have_selector('a', :href => followers_user_path(@user),
                                      :content => "1 follower")
      end

      describe "microposts" do

        it "should correctly report 0 microposts" do
          get :home
          response.should have_selector('span.microposts',
                                        :content => '0 microposts')
        end

        it "should correctly report 1 micropost" do
          Factory(:micropost, :user => @user)
          get :home
          response.should have_selector('span.microposts',
                                        :content => '1 micropost')
        end

        it "should correctly report 3 microposts" do
          3.times { Factory(:micropost, :user => @user) }
          get :home
          response.should have_selector('span.microposts',
                                        :content => '3 microposts')
        end

        it "should paginate microposts" do
          31.times { Factory(:micropost, :user => @user) }
          get :home
          response.should have_selector('div.pagination')
          response.should have_selector('span.disabled', :content => 'Previous')
          response.should have_selector('a', :href => '/?page=2',
                                             :content => '2')
          response.should have_selector('a', :href => '/?page=2',
                                             :content => 'Next')
        end

        describe "for the user owning the micropost" do

          it "should have a delete link" do
            3.times { Factory(:micropost, :user => @user) }
            get :home
            @user.microposts.each do |micropost|
              response.should have_selector('a',
                                            :href => micropost_path(micropost),
                                            :content => 'delete')
            end
          end
        end

        describe "for a user not owning the micropost" do

          it "should not have a delete link" do
            another_user = Factory(:user, :email => Factory.next(:email))
            micropost = Factory(:micropost, :user => another_user)
            @user.follow!(another_user)
            get :home
            response.should_not have_selector('a',
                                            :href => micropost_path(micropost),
                                            :content => 'delete')
          end
        end
      end
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
                                    :content => @base_title + "Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                                    :content => @base_title + "About")
    end
  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.should have_selector("title",
                                    :content => @base_title + "Help")
    end
  end
end
