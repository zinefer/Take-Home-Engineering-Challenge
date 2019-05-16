# frozen_string_literal: true

# Search Controller
class SearchController < ApplicationController
  def index
    # Populate filter dropdowns
    @boroughs = Borough.all

    # Table data
    @trips = Trip.includes(:pick_up_borough, :drop_off_borough)
    @trips = apply_trip_filters(@trips)
    @trips = @trips.order(pick_up_time: :desc).page params[:page]

    # Pie chart
    unless params[:vehicle_type].present?
      @trips_pie = Trip.all
      @trips_pie = apply_trip_filters(@trips_pie)
      @trips_pie = @trips_pie.group(:vehicle_type).count
    end

    # Line chart
    if params[:pick_up_day].present? && params[:pick_up_time].present?
      @trips_line = Trip.with_duration_and_minute
      @trips_line = apply_trip_filters(@trips_line)
      @trips_line = Trip.connection.execute("SELECT pick_up_minute, avg(duration) as avg_duration from (#{@trips_line.to_sql}) group by pick_up_minute")
      @trips_line.map! do |row|
        [row['pick_up_minute'], format_seconds_display(row['avg_duration'])]
      end
    elsif params[:pick_up_day].present?
      @trips_line = Trip.with_duration_and_hour
      @trips_line = apply_trip_filters(@trips_line)
      @trips_line = Trip.connection.execute("SELECT pick_up_hour, avg(duration) as avg_duration from (#{@trips_line.to_sql}) group by pick_up_hour")
      @trips_line.map! do |row|
        [Trip.format_hour(row['pick_up_hour']), format_seconds_display(row['avg_duration'])]
      end
    else
      @trips_line = Trip.with_duration_and_weekday
      @trips_line = apply_trip_filters(@trips_line)
      @trips_line = Trip.connection.execute("SELECT pick_up_day, avg(duration) as avg_duration from (#{@trips_line.to_sql}) group by pick_up_day")
      @trips_line.map! do |row|
        [Trip.day_of_week(row['pick_up_day']), format_seconds_display(row['avg_duration'])]
      end
    end
  end

  private

  def apply_trip_filters(trip)
    trip = trip.where(vehicle_type: params[:vehicle_type].downcase.to_sym) if params[:vehicle_type].present?
    trip = trip.where(pick_up_borough_id: params[:pick_up_borough]) if params[:pick_up_borough].present?
    trip = trip.where(drop_off_borough: params[:drop_off_borough]) if params[:drop_off_borough].present?
    trip = trip.filter_pick_up_weekday(params[:pick_up_day]) if params[:pick_up_day].present?
    trip = trip.filter_pick_up_time(params[:pick_up_time]) if params[:pick_up_time].present?
    trip
  end

  def format_seconds_display(seconds)
    (seconds / 60).round
  end
end
