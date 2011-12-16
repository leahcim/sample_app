# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  validates :user_id, :presence => true
  validates :content, :presence => true, :length => { :maximum => 140 }

  default_scope :order => "microposts.created_at DESC"

  # Return microposts by users being followed by the given user
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private

    # Return an SQL condition for users followed by the given user.
    # We include the user's own id as well.
    def self.followed_by(user)
      following_ids = Relationship.select(:followed_id).
                                   where(:follower_id => user).to_sql

      self.where("user_id = :user_id OR user_id IN (#{following_ids})",
                 :user_id => user)
    end
end
