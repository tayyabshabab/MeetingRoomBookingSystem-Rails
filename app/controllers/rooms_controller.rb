class RoomsController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    @rooms = Room.paginate(page: params[:page])
  end

  def show
    @room = Room.find(params[:id])
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      flash[:success] = "Room created successfully!"
      redirect_to @room
    else
      render 'new'
    end
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])
    if @room.update_attributes(room_params)
      flash[:success] = "Room updated successfully!"
      redirect_to @room
    else
      render 'edit'
    end
  end

  def destroy
    Room.find(params[:id]).destroy
    flash[:success] = "Room deleted successfully!"
    redirect_to rooms_path
  end

  def bookings
    @room = Room.find(params[:id])
    @bookings = @room.bookings.paginate(page: params[:page])
    @booking = @room.bookings.build
  end

  private

    def room_params
      params.require(:room).permit(:room_no, :building, :address)
    end

end
