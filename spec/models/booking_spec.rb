require 'spec_helper'

describe Booking do

  before do
    user = FactoryGirl.create(:user)
    room = FactoryGirl.create(:room)
    @booking = Booking.new(user: user, room: room, from_time: Time.now,
                            to_time: Time.now + (60*60*2))
  end

  subject { @booking }

  it { should respond_to(:user) }
  it { should respond_to(:room) }
  it { should respond_to(:from_time) }
  it { should respond_to(:to_time) }

  it { should be_valid }

  describe "when from time is not present" do
    before { @booking.from_time = " " }
    it { should_not be_valid }
  end

  describe "when to time is not present" do
    before { @booking.to_time = " " }
    it { should_not be_valid }
  end

end
