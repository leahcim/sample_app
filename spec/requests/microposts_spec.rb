require 'spec_helper'

describe "Microposts" do

  before(:each) do
    @user = Factory(:user)
    visit signin_path
    fill_in :email,    :with => @user.email
    fill_in :password, :with => @user.password
    click_button
  end

  describe "creation" do

    describe "failure" do
      it "should not make a new micropost" do
        lambda do
          visit root_path
          fill_in :micropost_content, :with => ''
          click_button
          response.should render_template('pages/home')
          response.should have_selector('div#error_explanation')
        end.should_not change(Micropost, :count)
      end
    end

    describe "success" do
      it "should make a new micropost" do
        content = "Lorem ipsum dolor sit amet"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector('span.content', :content => content)
        end.should change(Micropost, :count).by(1)
      end
    end
  end

  describe "deletion" do

    before(:each) do
      visit root_path
      fill_in :micropost_content, :with => "example"
      click_button
    end

    it "should return to the home page" do
      visit root_path
      click_link 'delete', :method => :delete
      response.should have_selector('title', :content => 'Home')
    end

    it "should return to the user's 'show' page" do
      visit user_path @user
      click_link 'delete', :method => :delete
      response.should have_selector('title', :content => "| #{@user.name}")
    end

    it "should return to the user's 'all microposts' page" do
      visit user_microposts_path @user
      click_link 'delete', :method => :delete
      response.should have_selector('title', :content => "All microposts by #{@user.name}")
    end
  end
end
