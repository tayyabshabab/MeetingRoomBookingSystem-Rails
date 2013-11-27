class Room < ActiveRecord::Base
  has_many :bookings, dependent: :destroy
  validates :room_no, presence: true
end
