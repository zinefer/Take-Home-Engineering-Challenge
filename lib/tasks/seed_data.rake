# frozen_string_literal: true

# lib/tasks/custom_seed.rake
namespace :db do
  namespace :seed do
    data_filename = Rails.root.join('db', 'data.rb')
    desc 'Loads the seed data from db/data.rb'
    task data: :environment do
      load(data_filename)
    end
  end
end
