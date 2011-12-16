# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                   "Test User"
  user.email                  "test@example.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.content      'Foo bar'
  micropost.association  :user
end

Factory.define :relationship do |relationship|
  relationship.association :follower, :factory => :user
  relationship.association :followed, :factory => :user
end
