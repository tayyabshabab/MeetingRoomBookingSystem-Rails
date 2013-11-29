require 'spec_helper'

describe BookingsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:room) { FactoryGirl.create(:room) }
  let(:booking) { FactoryGirl.create(:booking, user: user, room: room) }

  describe "GET # new" do
    it "it redirects non logged in user to signin" do
      get :new, id: room
      response.should redirect_to :signin
    end

    describe "when logged in" do
      before { login(user) }

      it "locates the requested room" do
        get :new, id: room
        assigns(:room).should eq(room)
      end

      it "builds new booking in @booking" do
        get :new, id: room
        assigns(:booking).should be_a_new(Booking)
      end

      it "renders the :new template" do
        get :new, id: room
        response.should render_template :new
      end
    end
  end

  describe "POST # create" do
    it "it redirects non logged in user to signin" do
      post :create, id: room,
                      booking: FactoryGirl.attributes_for(:booking, user: user, room: room)
      response.should redirect_to :signin
    end

    describe "when logged in" do
      before { login(user) }

      context "with valid attributes" do
        it "saves the new booking in database" do
          expect {
            post :create, id: room,
                      booking: FactoryGirl.attributes_for(:booking, user: user, room: room)
          }.to change(Booking, :count).by(1)
        end

        it "redirects to room's bookings" do
          post :create, id: room,
                      booking: FactoryGirl.attributes_for(:booking, user: user, room: room)
          response.should redirect_to bookings_room_path(room)
        end
      end

      context "with invalid attributes" do
        it "does not save the new booking in database" do
          expect {
            post :create, id: room,
                        booking: FactoryGirl.attributes_for(:invalid_booking)
          }.not_to change(Booking, :count)
        end

        it "re-renders the :bookings template of rooms" do
          post :create, id: room,
                      booking: FactoryGirl.attributes_for(:invalid_booking)
          response.should render_template 'rooms/bookings'
        end
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @booking = FactoryGirl.create(:booking, user: user, room: room)
    end

    it "redirects non logged in users to signin page" do
      delete :destroy, id: @booking
      response.should redirect_to :signin
    end

    it "redirects non admin user to root" do
      login(user)
      delete :destroy, id: @booking
      response.should redirect_to :root
    end

    describe "when admin" do
      before { login(admin) }

      it "deletes the booking" do
        expect {
          delete :destroy, id: @booking
        }.to change(Booking, :count).by(-1)
      end

      it "redirects to room # bookings" do
        delete :destroy, id: @booking
        response.should redirect_to bookings_room_path(room)
      end
    end
  end

end