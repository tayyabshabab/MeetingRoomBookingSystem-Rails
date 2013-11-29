require 'spec_helper'

describe RoomsController do

  let(:room) { FactoryGirl.create(:room) }
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  describe "GET # index" do
    it "redirects non logged in users to signin page" do
      get :index
      response.should redirect_to :signin
    end

    describe "when logged in" do
      before { login(user) }

      it "populates array of rooms" do
        get :index
        assigns(:rooms).should eq([room])
      end

      it "renders the :index view" do
        get :index
        response.should render_template :index
      end
    end
  end

  describe "GET # show" do
    it "redirects non logged in users to signin page" do
      get :show, id: room
      response.should redirect_to :signin
    end

    describe "when logged in" do
      before { login(user) }

      it "populates the room" do
        get :show, id: room
        assigns(:room).should eq(room)
      end

      it "renders the :show template" do
        get :show, id: room
        response.should render_template :show
      end
    end
  end

  describe "GET # new" do
    it "redirects non logged in users to signin page" do
      get :new
      response.should redirect_to :signin
    end

    it "redirects non admin user to root" do
      login(user)
      get :new
      response.should redirect_to :root
    end

    describe "when admin user" do
      before { login(admin) }

      it "assigns a new room to @room" do
        get :new
        expect(assigns(:room)).to be_a_new(Room)
      end

      it "renders the :new template" do
        get :new
        response.should render_template :new
      end
    end
  end

  describe "POST # create" do
    it "redirects non logged in users to signin page" do
      post :create, room: FactoryGirl.attributes_for(:room)
      response.should redirect_to :signin
    end

    it "redirects non admin user to root" do
      login(user)
      post :create, room: FactoryGirl.attributes_for(:room)
      response.should redirect_to :root
    end

    describe "when admin user" do
      before { login(admin) }

      context "with valid attributes" do
        it "saves the new room in database" do
          expect {
            post :create, room: FactoryGirl.attributes_for(:room)
          }.to change(Room, :count).by(1)
        end

        it "redirects to the new room" do
          post :create, room: FactoryGirl.attributes_for(:room)
          response.should redirect_to Room.last
        end
      end

      context "with invalid attributes" do
        it "does not save the new room in database" do
          expect {
            post :create, room: FactoryGirl.attributes_for(:invalid_room)
          }.not_to change(Room, :count)
        end

        it "re-renders the :new template" do
          post :create, room: FactoryGirl.attributes_for(:invalid_room)
          response.should render_template :new
        end
      end
    end
  end

  describe "GET # edit" do
    it "redirects non logged in users to signin page" do
      get :edit, id: room
      response.should redirect_to :signin
    end

    it "redirects non admin user to root" do
      login(user)
      get :edit, id: room
      response.should redirect_to :root
    end

    describe "when admin" do
      before { login(admin) }

      it "locates the requested @room" do
        get :edit, id: room
        assigns(:room).should eq(room)
      end

      it "renders the :edit template" do
        get :edit, id: room
        response.should render_template :edit
      end
    end
  end

  describe "PUT update" do
    before :each do
      @room = FactoryGirl.create(:room, room_no: "222")
    end

    it "redirects non logged in users to signin page" do
      put :update, id: @room
      response.should redirect_to :signin
    end

    it "redirects non admin user to root" do
      login(user)
      get :edit, id: @room
      response.should redirect_to :root
    end

    describe "when admin user" do
      before { login(admin) }

      context "with valid attributes" do
        it "locates the requested @room" do
          put :update, id: @room, room: FactoryGirl.attributes_for(:room)
          assigns(:room).should eq(@room)
        end

        it "changes @room's attributes" do
          put :update, id: @room, room: FactoryGirl.attributes_for(:room, room_no: "333")
          @room.reload
          @room.room_no.should eq("333")
        end

        it "redirects to the updated room" do
          put :update, id: @room, room: FactoryGirl.attributes_for(:room)
          response.should redirect_to @room
        end
      end

      context "with invalid attributes" do
        it "locates the requested @room" do
          put :update, id: @room, room: FactoryGirl.attributes_for(:room)
          assigns(:room).should eq(@room)
        end

        it "does not change @room attributes" do
          put :update, id: @room, room: FactoryGirl.attributes_for(:invalid_room, building: "Panorama")
          @room.reload
          @room.building.should_not eq("Panorama")
          @room.room_no.should eq("222")
        end

        it "re-renders the :edit method" do
          put :update, id: @room, room: FactoryGirl.attributes_for(:invalid_room)
          response.should render_template :edit
        end
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @room = FactoryGirl.create(:room)
    end

    it "redirects non logged in users to signin page" do
      delete :destroy, id: @room
      response.should redirect_to :signin
    end

    it "redirects non admin user to root" do
      login(user)
      delete :destroy, id: @room
      response.should redirect_to :root
    end

    describe "when admin user" do
      before { login(admin) }

      it "deletes the room" do
        expect {
          delete :destroy, id: @room
        }.to change(Room, :count).by(-1)
      end

      it "redirects to rooms # index" do
        delete :destroy, id: @room
        response.should redirect_to rooms_url
      end
    end
  end

  describe "GET bookings" do
    it "redirects non logged in users to signin page" do
      get :bookings, id: room
      response.should redirect_to :signin
    end

    describe "when logged in" do
      before do
        login(user)
        @booking = FactoryGirl.create(:booking, user: user, room: room)
      end

      it "locates the requested @room" do
        get :bookings, id: room
        assigns(:room).should eq(room)
      end

      it "populates bookings in @bookings" do
        get :bookings, id: room
        assigns(:bookings).should eq([@booking])
      end

      it "builds new booking in @booking" do
        get :bookings, id: room
        assigns(:booking).should be_a_new(Booking)
      end
    end
  end

end