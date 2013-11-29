class Booking < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
  validates :from_time, presence: true
  validates :to_time, presence: true

  private

    def Booking.check_if_bookings_exist(from_time, to_time)
      b = Booking.where("(:f_time > from_time AND :f_time < to_time) OR (:t_time > from_time AND :t_time < to_time)", f_time: from_time, t_time: to_time)
      if b.count > 0
        true
      else
        false
      end
    end
end
