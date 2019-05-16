# frozen_string_literal: true

require 'test_helper'

require 'tempfile'

class SkimmableCSVTest < ActionDispatch::IntegrationTest
  def temp_file(content)
    file = Tempfile.new

    file.write(content.join("\n"))
    file.close

    yield file

    file.unlink
  end

  test 'it returns single chunks when processing a csv file' do
    temp_file ['"a","b","c"', '1,2,3', '4,"5",6', '7,8,9'] do |file|
      row_count = 0
      SkimmableCSV.process(file.path) do |chunk|
        row_count += chunk.count

        assert_equal 3, chunk[0].count, 'row size is as expected'
      end
      assert_equal 3, row_count, 'row count is as expected'
    end
  end

  test 'it doesnt mind a newline between header and data' do
    data = ['"along","came","polly\'s",kay', '', 'a,b,c,d', '1,"z??~~==++_",9,q', 'aa22,yy99,dd22,)', 'd,e,f,g']
    temp_file data do |file|
      row_count = 0

      SkimmableCSV.process(file.path) do |chunk|
        row_count += chunk.count

        assert_equal 4, chunk[0].count, 'row size is as expected'
      end

      assert_equal 4, row_count, 'row count is as expected'
    end
  end

  test 'it returns properly sized chunks' do
    data = ['a,small,elephant']

    12.times do |x|
      data << ["#{x},#{x},#{x}"]
    end

    temp_file data do |file|
      num_chunks = 0
      row_count = 0

      SkimmableCSV.process(file.path, chunk_size: 5) do |chunk|
        num_chunks += 1
        row_count += chunk.count
      end

      assert_equal 3, num_chunks, 'number of chunks returned is as expected'
      assert_equal 12, row_count, 'row count is as expected'
    end
  end
end
