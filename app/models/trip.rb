# frozen_string_literal: true

# Trip model
class Trip < ApplicationRecord
  belongs_to :pick_up_borough, class_name: 'Borough'
  belongs_to :drop_off_borough, class_name: 'Borough'

  enum vehicle_type: %i[fhv green yellow]

  scope :filter_pick_up_weekday, ->(day_of_week) { where("strftime('%w', pick_up_time) = ?", day_of_week.to_s) }
  scope :filter_pick_up_time,    ->(time_of_day) { where("strftime('%H', pick_up_time) = ?", time_of_day.to_s) }

  scope :with_duration_and_weekday, -> { select('trips.*, (julianday(drop_off_time) - julianday(pick_up_time)) * 86400.0 as duration, strftime("%w", pick_up_time) as pick_up_day') }
  scope :with_duration_and_hour, -> { select('trips.*, (julianday(drop_off_time) - julianday(pick_up_time)) * 86400.0 as duration, strftime("%H", pick_up_time) as pick_up_hour') }
  scope :with_duration_and_minute, -> { select('trips.*, (julianday(drop_off_time) - julianday(pick_up_time)) * 86400.0 as duration, strftime("%M", pick_up_time) as pick_up_minute') }

  def self.day_of_week(numeric)
    %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday][numeric.to_i]
  end

  def self.day_of_week_options
    [['Sunday', 0], ['Monday', 1], ['Tuesday', 2], ['Wednesday', 3], ['Thursday', 4], ['Friday', 5], ['Saturday', 6]]
  end

  def self.time_of_day_options
    (0...24).map do |hour|
      [format_hour(hour), format('%02i', hour)]
    end
  end

  def self.format_hour(hour)
    Time.parse("#{hour}:00").strftime('%l %p')
  end
end
