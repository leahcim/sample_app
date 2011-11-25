require 'spec_helper'

describe MicropostsController do
  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      post :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "GET 'index'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "for an existing user" do

      it "should show the index page" do
        get :index, :user_id => @user
        response.should be_successful
      end

      it "should show all microposts" do
        31.times { Factory(:micropost, :user => @user) }
        get :index, :user_id => @user
        @user.microposts.each do |micropost|
          response.should have_selector('.micropost',
                                        :content => micropost.content)
        end
      end
    end

    describe "for a non-existent user" do

      it "should re-direct to the root path" do
        get :index, :user_id => 'WRONG-ID'
        response.should redirect_to root_path
      end
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "failure" do

      before(:each) do
        @attr = { :content => "  " }
      end

      it "should not create a micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should_not change(Micropost, :count)
      end

      it "should render the home page" do
        post :create, :micropost => @attr
        response.should render_template('pages/home')
      end

      describe "microposts feed" do

        it "should list user's microposts" do
          Factory(:micropost, :user => @user)
          post :create, :micropost => @attr
          response.should have_selector('.content')
        end

        it "should have pagination links pointing to the 'home' page" do
          31.times { Factory(:micropost, :user => @user) }
          post :create, :micropost => @attr
          response.should have_selector('a', :href => '/?page=2',
                                             :content => 'Next' )
        end
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :content => 'Lorem ipsum' }
      end

      it "should create a micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should change(Micropost, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, :micropost => @attr
        response.should redirect_to(root_path)
      end

      it "should have a flash message" do
        post :create, :micropost => @attr
        flash[:success].should =~ /micropost created/i
      end
    end
  end

  describe "DELETE 'destroy" do

    describe "for unauthorised users" do

      before(:each) do
        @user = Factory(:user)
        @micropost = Factory(:micropost, :user => @user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(wrong_user)
      end

      it "should deny access" do
        delete :destroy, :id => @micropost
        response.should redirect_to(root_path)
      end

      it "should not delete the micropost" do
        lambda do
          delete :destroy, :id => @micropost
        end.should_not change(Micropost, :count)
      end
    end

    describe "for authorised users" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should destroy the micropost" do
        lambda do
          delete :destroy, :id => @micropost
        end.should change(Micropost, :count).by(-1)
      end
    end
  end
end
