# frozen_string_literal: true

# Search Controller
class SearchController < ApplicationController
  def index
    @boroughs = Borough.all
    @trips = Trip.includes(:pick_up_borough, :drop_off_borough)

    @trips = @trips.where(vehicle_type: params[:vehicle_type].downcase.to_sym) if params[:vehicle_type].present?
    @trips = @trips.where(pick_up_borough_id: params[:pick_up_borough]) if params[:pick_up_borough].present?
    @trips = @trips.where(drop_off_borough: params[:drop_off_borough]) if params[:drop_off_borough].present?
    @trips = @trips.filter_pick_up_weekday(params[:pick_up_day]) if params[:pick_up_day].present?
    @trips = @trips.filter_pick_up_time(params[:pick_up_time]) if params[:pick_up_time].present?

    @trips = @trips.order(pick_up_time: :desc).page params[:page]
  end
end
