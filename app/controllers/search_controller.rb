# frozen_string_literal: true

# Search Controller
class SearchController < ApplicationController
  def index
    @boroughs = Borough.all
    @trips = Trip.all.order(pick_up_time: :desc).page params[:page]
  end
end
