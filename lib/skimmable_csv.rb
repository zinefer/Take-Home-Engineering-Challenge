# frozen_string_literal: true

# A simple CSV parser that is capable of returning a subsample of a file
class SkimmableCSV
  def self.process(input, options = {})
    # Return chunk_size number of rows to the block on every iteration
    chunk_size = options[:chunk_size].to_i || 1
    chunk = []

    headers = []

    file_line_count = 0
    file = File.open(input)

    # Don't slurp the entire file! One line at a time ...
    until file.eof?
      line = file.readline
      file_line_count += 1

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

      next unless chunk.size >= chunk_size || file.eof?

      # Pass the block our rows and reset
      yield chunk
      chunk.clear
    end

    file.close
  end
end
