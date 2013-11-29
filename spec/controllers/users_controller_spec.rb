require 'spec_helper'

describe UsersController do

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  describe "GET # index" do
    it "redirects non logged in user to signin page" do
      get :index
      response.should redirect_to :signin
    end

    it "redirects non admin users to root" do
      login(user)
      get :index
      response.should redirect_to :root
    end

    describe "when admin" do
      before { login(admin) }

      it "populates array of users" do
        get :index
        assigns(:users).should eq([admin, user])
      end

      it "renders the :index view" do
        get :index
        response.should render_template :index
      end
    end
  end

  describe "GET # show" do
    it "redirects non logged in user to signin page" do
      get :show, id: user
      response.should redirect_to :signin
    end

    describe "when signed in" do
      before { login(user) }

      it "populates the user" do
        get :show, id: user
        assigns(:user).should eq(user)
      end

      it "renders the :show template" do
        get :show, id: user
        response.should render_template :show
      end

    end
  end

  describe "GET # new" do

    it "redirects non logged in user to signin page" do
      get :new
      response.should redirect_to :signin
    end

    describe "when signed in" do
      before { login(user) }

      it "assigns a new User to @user" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end

      it "renders the :new template" do
        get :new
        response.should render_template :new
      end
    end
  end

  describe "POST # create" do

    it "redirects non logged in user to signin page" do
      post :create, user: FactoryGirl.attributes_for(:user)
      response.should redirect_to :signin
    end

    describe "when logged in" do
      before { login(user) }

      context "with valid attributes" do
        it "saves the new user in database" do
          expect {
            post :create, user: FactoryGirl.attributes_for(:user)
          }.to change(User, :count).by(1)
        end

        it "redirects to user detail page" do
          post :create, user: FactoryGirl.attributes_for(:user)
          response.should redirect_to User.last
        end
      end

      context "with invalid attributes" do
        it "does not save the new user in the database" do
          expect {
            post :create, user: FactoryGirl.attributes_for(:invalid_user)
          }.not_to change(User, :count)
        end

        it "re-renders the :new template" do
          post :create, user: FactoryGirl.attributes_for(:invalid_user)
          response.should render_template :new
        end
      end
    end
  end

  describe "GET # edit" do
    before :each do
      @user = FactoryGirl.create(:user, name: "Previous Name", email: "previous@email.com")
    end

    it "redirects non logged in users to signin page" do
      get :edit, id: @user
      response.should redirect_to :signin
    end

    it "redirects non admin user to root" do
      login(user)
      get :edit, id: @user
      response.should redirect_to :root
    end

    describe "when admin" do
      before { login(@user) }

      it "locates the requested user" do
        get :edit, id: @user
        assigns(:user).should eq(@user)
      end

      it "renders the :edit template" do
        get :edit, id: @user
        response.should render_template :edit
      end
    end
  end

  describe "PUT update" do
    before :each do
      @user = FactoryGirl.create(:user, name: "Previous Name", email: "previous@email.com")
    end

    it "redirects non logged in user to signin page" do
      put :update, id: @user, user: FactoryGirl.attributes_for(:user)
      response.should redirect_to :signin
    end

    it "redirect wrong user to root" do
      login(user)
      put :update, id: @user, user: FactoryGirl.attributes_for(:user)
      response.should redirect_to :root
    end

    describe "when logged in with correct user" do
      before { login(@user) }

      context "with valid attributes" do
        it "locates the requested @user" do
          put :update, id: @user, user: FactoryGirl.attributes_for(:user)
          assigns(:user).should eq(@user)
        end

        it "changes @user's attributes" do
          put :update, id: @user, user: FactoryGirl.attributes_for(:user, name: "new_name",
                                      email: "new@email.com")
          @user.reload
          @user.name.should eq("new_name")
          @user.email.should eq("new@email.com")
        end

        it "redirects to the updated user" do
          put :update, id: @user, user: FactoryGirl.attributes_for(:user)
          response.should redirect_to @user
        end
      end

      context "with invalid attributes" do
        it "locates the requested @user" do
          put :update, id: @user, user: FactoryGirl.attributes_for(:invalid_user)
          assigns(:user).should eq(@user)
        end

        it "does not change @user's attributes" do
          put :update, id: @user, user: FactoryGirl.attributes_for(:user, name: "new_name",
                                      email: nil)
          @user.reload
          @user.name.should_not eq("new_name")
          @user.email.should eq("previous@email.com")
        end

        it "re-renders the edit method" do
          put :update, id: @user, user: FactoryGirl.attributes_for(:invalid_user)
          response.should render_template :edit
        end
      end
    end
  end

  describe "DELETE # destroy" do
    before :each do
      @user = FactoryGirl.create(:user)
    end

    it "redirects non logged in user to signin page" do
      delete :destroy, id: @user
      response.should redirect_to :signin
    end

    it "redirects non admin user to root" do
      login(user)
      delete :destroy, id: @user
      response.should redirect_to :root
    end

    describe "when logged in with admin" do
      before { login(admin) }

      it "deletes the user" do
        expect {
          delete :destroy, id: @user
        }.to change(User, :count).by(-1)
      end

      it "redirects to users#index" do
        delete :destroy, id: @user
        response.should redirect_to users_url
      end
    end
  end

end