class Booking < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
  validates :from_time, presence: true
  validates :to_time, presence: true
  validate :from_time_is_valid_time?
  validate :to_time_is_valid_time?

  private

    def from_time_is_valid_time?
      errors.add(:from_time, 'must be a valid date') if !from_time.is_a?(Time)
    end

    def to_time_is_valid_time?
      errors.add(:to_time, 'must be a valid date') if !to_time.is_a?(Time)
    end

    def Booking.check_if_bookings_exist(from_time, to_time)
      b = Booking.where("(:f_time > from_time AND :f_time < to_time) OR (:t_time > from_time AND :t_time < to_time)", f_time: from_time, t_time: to_time)
      if b.count > 0
        true
      else
        false
      end
    end
end
