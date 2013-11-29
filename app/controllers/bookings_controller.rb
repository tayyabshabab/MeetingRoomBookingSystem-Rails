class BookingsController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user, only: [:destroy]

  def new
    @room = Room.find(params[:id])
    @booking = @room.bookings.build
  end

  def create
    from_time = params[:booking][:from_time]
    to_time = params[:booking][:to_time]

    @room = Room.find(params[:id])
    @bookings = @room.bookings.paginate(page: params[:page])
    @booking = @room.bookings.build(booking_params)
    @booking.user_id = current_user.id

    if (!from_time.empty? && !to_time.empty?)
      if (from_time.to_time.to_i > to_time.to_time.to_i)
        flash.now[:warning] = "To time cannot be less than from time"
        return render 'rooms/bookings'
      elsif (Booking.check_if_bookings_exist from_time, to_time)
        flash.now[:warning] = "This room is already booked during this time!"
        render 'rooms/bookings'
      else
        if (@booking.save)
          flash[:success] = "Booking placed successfully!"
          redirect_to bookings_room_path(@room)
        else
          render 'rooms/bookings'
        end
      end
    else
      @booking.save
      render 'rooms/bookings'
    end
  end

  def destroy
    booking = Booking.find(params[:id])
    room = booking.room;
    booking.destroy
    flash[:success] = "Booking deleted successfully!"
    redirect_to bookings_room_path(room)
  end

  private

    def booking_params
      params.require(:booking).permit(:from_time, :to_time)
    end

end
