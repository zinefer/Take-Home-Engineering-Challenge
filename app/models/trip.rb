# frozen_string_literal: true

# Trip model
class Trip < ApplicationRecord
  belongs_to :pick_up_borough, class_name: 'Borough'
  belongs_to :drop_off_borough, class_name: 'Borough'

  enum vehicle_type: %i[fhv green yellow]
end
