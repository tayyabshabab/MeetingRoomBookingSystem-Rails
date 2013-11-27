class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :user_id
      t.integer :room_id
      t.datetime :from_time
      t.datetime :to_time

      t.timestamps
    end
  end
end
