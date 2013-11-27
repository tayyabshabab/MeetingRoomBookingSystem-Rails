class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :room_no
      t.string :building
      t.string :address

      t.timestamps
    end
  end
end
