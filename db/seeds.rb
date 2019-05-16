# frozen_string_literal: true

require 'csv'

# Pass a csv file and a block this function will call the block with every row of the csv
# and report progress to the standard output
def each_as_csv(file)
  # Path to csv file
  tripdata_csv_path = Rails.root.join('db', 'data', file)

  # Number of lines in file
  total_trips = File.foreach(tripdata_csv_path).count - 1

  progress = ProgressBar.create(title: "Import #{file}", total: total_trips, format: '[%a] %B [%p%%] %t', length: 100)

  CSV.foreach(tripdata_csv_path, headers: true) do |row|
    yield(row)

    progress.increment
  end
end

# Import taxi data
each_as_csv('taxi+_zone_lookup.csv') do |row|
  # Filter the incoming data
  data = { id: row['LocationID'], name: row['Borough'], zone: row['Zone'], service_zone: row['service_zone'] }
  # Insert it into the database
  Borough.create!(data)
end

# Loop over all the trip data csv
['fhv_tripdata_2018-01.csv', 'green_tripdata_2018-01.csv', 'yellow_tripdata_2018-01.csv'].each do |file|
  # Pull the trip type off the begininng of the filename
  trip_type = file.split('_').first

  each_as_csv(file) do |row|
    data = { pick_up_time: row['Pickup_DateTime'], drop_off_time: row['DropOff_datetime'],
             pick_up_borough_id: row['PUlocationID'], drop_off_borough_id: row['DOlocationID'],
             vehicle_type: trip_type }

    Trip.create!(data)
  end
end
