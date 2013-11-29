FactoryGirl.define do
  factory :room do
    room_no "1"
    building "Videum"
    address "Vaxjo"
  end

  factory :invalid_room, parent: :room do |r|
    r.room_no nil
  end
end