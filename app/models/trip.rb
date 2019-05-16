# frozen_string_literal: true

# Trip model
class Trip < ApplicationRecord
  belongs_to :pick_up_borough, class_name: 'Borough'
  belongs_to :drop_off_borough, class_name: 'Borough'

  enum vehicle_type: %i[fhv green yellow]

  def self.day_of_week_options
    [['Sunday', 0],['Monday', 1],['Tuesday', 2],['Wednesday', 3],['Thursday', 4],['Friday', 5],['Saturday', 6]]
  end
  def self.time_of_day_options
    (0...24).map do |hour|
       [Time.parse("#{hour}:00").strftime("%l %p"), format('%02i', hour)]
    end
  end
end
