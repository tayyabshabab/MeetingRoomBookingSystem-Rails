FactoryGirl.define do
  factory :booking do
    from_time Time.now
    to_time Time.now + (60*60*2)
    user
    room
  end

  factory :invalid_booking, parent: :booking do |b|
    b.from_time ""
    b.to_time ""
  end
end