# frozen_string_literal: true

FactoryBot.define do
  factory :trip do
    vehicle_type { Trip.vehicle_types.keys.to_a.sample(1)[0] }
    pick_up_time { Faker::Date.between(10.year.ago, 5.year.ago) }
    drop_off_time { Faker::Date.between(10.year.ago, 5.year.ago) }
    pick_up_borough_id { FactoryBot.create(:borough).id }
    drop_off_borough_id { FactoryBot.create(:borough).id }
  end
end
