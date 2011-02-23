require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => 'Example User', :email => 'user@example.com' }
  end

  it 'should require a name' do
    no_name_user = User.new(@attr.merge( :name => '' ))
    no_name_user.should_not be_valid
  end

  it 'should requre an email address' do
    no_email_user = User.new(@attr.merge( :email => '' ))
    no_email_user.should_not be_valid
  end

  it 'should reject names that are too long' do
    long_name = 'a' * 51
    long_name_user = User.new(@attr.merge( :name => long_name ))
    long_name_user.should_not be_valid
  end

  it 'should accept valid email addresses' do
    addresses = %w[ user@foo.com example_user@foo.bar.org first.last@foo.jp ]
    addresses.each do |address|
      valid_email_user = User.new( @attr.merge( :email => address ))
      valid_email_user.should be_valid
    end
  end

  it 'should reject invalid email addresses' do
    addresses = %w[ user@foo,com user_at_foo.org user@foo. ]
    addresses.each do |address|
      invalid_email_user = User.new( @attr.merge( :email => address ))
      invalid_email_user.should_not be_valid
    end
  end

  it 'should reject duplicate email addresses' do
    # Create a user record with given email address
    User.create!(@attr)
    duplicate_email_user = User.new(@attr)
    duplicate_email_user.should_not be_valid
  end

  it 'should reject emails identical up to case' do
    upcased_email = @attr[:email].upcase
    User.create(@attr.merge( :email => upcased_email ))
    duplicate_email_user = User.new(@attr)
    duplicate_email_user.should_not be_valid
  end
end
