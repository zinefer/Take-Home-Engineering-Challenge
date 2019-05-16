# frozen_string_literal: true

# To facilitate development we will allow a limit for the amount of data to be processed
@row_limit = ENV['TRIPDATA_SAMPLE'].to_i || 0

# Pass a csv file and a block to this function will call the block with every row of the csv
# and report progress to the standard output
def each_as_csv(path)
  # Number of lines in file
  # TODO: only calculate this once
  total_rows = File.foreach(path).count - 1

  file_name = File.basename(path)

  # Reduce the total_rows if the tripdata_row_limit is smaller
  total_rows = [total_rows, @row_limit].min if @row_limit.positive?

  # ProgressBar to give some feedback since this is a large job
  progress = ProgressBar.create(title: "Import #{file_name}", total: total_rows, format: '[%a] %B [%p%%] %t', length: 100)

  SkimmableCSV.process(path, chunk_size: 5, sample_size: @row_limit) do |chunk|
    chunk.each do |row|
      # Replace empty strings with nil
      row.delete_if { |_k, s| s&.empty? }

      begin
        yield(row)
      rescue ActiveRecord::ActiveRecordError => e
        puts "Warning: Bad data (#{e.class}) #{row.inspect}"
      end

      progress.increment
    end
  end
end

# Import taxi data
taxi_csv = Rails.root.join('db', 'data', 'taxi+_zone_lookup.csv')
each_as_csv(taxi_csv) do |row|
  # Filter the incoming data
  data = { id: row['LocationID'], name: row['Borough'], zone: row['Zone'], service_zone: row['service_zone'] }
  # Insert it into the database
  Borough.create!(data)
end

# Loop over all the trip data csv files
Dir.glob(['db/data/*_tripdata_*.csv']).each do |path|
  # Pull the trip_type off the begininng of the filename
  trip_type = File.basename(path).split('_').first

  each_as_csv(path) do |row|
    case trip_type.to_sym
    when :fhv
      data = { pick_up_time: row['Pickup_DateTime'], drop_off_time: row['DropOff_datetime'],
               pick_up_borough_id: row['PUlocationID'], drop_off_borough_id: row['DOlocationID'],
               vehicle_type: trip_type }
    when :green
      data = { pick_up_time: row['lpep_pickup_datetime'], drop_off_time: row['lpep_dropoff_datetime'],
               pick_up_borough_id: row['PULocationID'], drop_off_borough_id: row['DOLocationID'],
               fare: row['total_amount'], vehicle_type: trip_type }
    when :yellow
      data = { pick_up_time: row['tpep_pickup_datetime'], drop_off_time: row['tpep_dropoff_datetime'],
               pick_up_borough_id: row['PULocationID'], drop_off_borough_id: row['DOLocationID'],
               fare: row['total_amount'], vehicle_type: trip_type }
    end

    # Incomplete data, just ignore it because there is a lot ...
    next unless data[:pick_up_borough_id] && data[:drop_off_borough_id]

    Trip.create!(data)
  end
end
