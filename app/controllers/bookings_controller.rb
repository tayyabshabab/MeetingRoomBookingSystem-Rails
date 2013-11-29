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
      find_bookings_in_between_dates = Booking.where("(:f_time > from_time AND :f_time < to_time) OR (:t_time > from_time AND :t_time < to_time)", f_time: from_time, t_time: to_time)

      if (find_bookings_in_between_dates.size > 0)
        flash[:warning] = "This room is already booked during this time!"
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
