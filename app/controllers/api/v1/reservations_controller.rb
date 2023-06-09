class Api::V1::ReservationsController < ApplicationController
  # CSRF Token Validations SKIP
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def index
    @reservations = Reservation.all.order(:id)
    render json: @reservations
  end

  def reserve
    # Create an instance of reservation
    reservation = Reservation.new(city: params[:city], duration_of_test_drive: params[:duration_of_test_drive],
                                  date_of_reservation: params[:date_of_reservation], user_id: params[:user_id],
                                  twowheeler_id: params[:twowheeler_id])
    # Check for validation
    if !reservation.valid?
      render status: 400, json: { message: 'Bad request.', status: 400 }
    elsif reservation.save
      # If it is valid save
      render status: 201, json: { message: 'Reservation made successfully.', data: reservation, status: 201 }
    else
      render status: 500, json: { message: 'Something went wrong please try again later.', status: 500 }
    end
  end

  def checkout
    # Check for availablity
    reservation = Reservation.find_by(id: params[:id])
    if reservation.nil?
      render status: 404, json: { message: 'Reservation could not be found.', status: 404 }
    elsif reservation.destroy
      # If Available destroy
      render status: 200, json: { message: 'Reservation have been removed', status: 200 }
    else
      render status: 500, json: { message: 'Something went wrong please try again later.', status: 500 }
    end
  end
end
