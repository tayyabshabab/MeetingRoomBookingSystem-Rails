require 'spec_helper'

describe Room do

  before do
    @room = Room.new(room_no: "1")
  end

  subject { @room }

  it { should respond_to(:room_no) }
  it { should respond_to(:building) }
  it { should respond_to(:address) }
  it { should respond_to(:bookings) }

  it { should be_valid }

  describe "when room number is not present" do
    before { @room.room_no = " " }
    it { should_not be_valid }
  end

  describe "booking associations" do
    before do
      @room.save
      @user = FactoryGirl.create(:user)
    end
    let!(:booking_one) { FactoryGirl.create(:booking, user: @user, room: @room) }
    let!(:booking_two) { FactoryGirl.create(:booking, user: @user, room: @room) }

    it "should have the right bookings in the right order" do
      expect(@room.bookings.to_a).to eq [booking_one, booking_two]
    end

    it "should destroy associated bookings" do
      bookings = @room.bookings.to_a
      @room.destroy
      expect(bookings).not_to be_empty
      bookings.each do |booking|
        expect(Booking.where(id: booking.id)).to be_empty
      end
    end
  end

end
