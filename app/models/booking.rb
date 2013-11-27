class Booking < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
  validates :from_time, presence: true
  validates :to_time, presence: true
end
