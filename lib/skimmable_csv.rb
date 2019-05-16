# frozen_string_literal: true

# A simple CSV parser that is capable of returning a subsample of a file
class SkimmableCSV
  def self.process(input, options = {})
    # Return chunk_size number of rows to the block on every iteration
    chunk_size = options[:chunk_size].to_i || 1
    chunk = []

    # Generate a random selection of lines to sample from the file
    sample_size = options[:sample_size].to_i || 0
    if sample_size.positive?
      total_lines = File.foreach(input).count
      sample_lines = (2..total_lines).to_a.sample(sample_size).sort
      sample_pointer = 0
    end

    headers = []

    file_line_count = 0
    file = File.open(input)

    # Don't slurp the entire file! One line at a time ...
    until file.eof?
      line = file.readline
      file_line_count += 1

      # If we're looking for a sample and we've already obtained the header
      if sample_size.positive? && file_line_count > 1
        # Skip the line unless it is interesting
        next unless sample_lines[sample_pointer] == file_line_count

        # Look for the next sample
        sample_pointer += 1

        # Stop looping over file lines if we have all our samples
        file.seek(0, IO::SEEK_END) if sample_pointer == sample_lines.count
      end

      # Remove newline from end of string
      line = line.chomp

      # Ignore empty lines
      next if line.empty?

      data = line.split(',').map do |val|
        # TODO: properly handle quotes
        val.delete_prefix('"').delete_suffix('"')
      end

      # First line is assumed to be the header, store this row and continue
      if file_line_count == 1
        headers = data
        next
      end

      # Zip the data with the headers and add it to the chunk
      chunk << headers.zip(data).to_h

      # Move on unless the chunk is ready to be output
      next unless chunk.size >= chunk_size || file.eof?

      # Pass the block our rows and reset
      yield chunk
      chunk.clear
    end

    file.close
  end
end
