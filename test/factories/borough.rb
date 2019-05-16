# frozen_string_literal: true

FactoryBot.define do
  factory :borough do
    name { Faker::Name.unique.name }
    zone { Faker::Space.planet }
  end
end
