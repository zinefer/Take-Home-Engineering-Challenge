# frozen_string_literal: true

require 'application_system_test_case'

class SearchTest < ApplicationSystemTestCase
  setup do
    30.times do
      FactoryBot.create(:trip)
    end

    @trip = FactoryBot.create(:trip)
  end

  test 'search the index' do
    visit root_url
    assert_selector '.brand', text: 'TripHelper.nyc'

    first_row_count = all('table.table tr').count

    assert_operator first_row_count, :>, 25

    # Fill search form
    find('select[name="vehicle_type"]').find(:xpath, 'option[2]').select_option
    find('select[name="pick_up_borough"]').find(:xpath, 'option[2]').select_option
    find('select[name="drop_off_borough"]').find(:xpath, 'option[2]').select_option
    find('select[name="pick_up_day"]').find(:xpath, 'option[2]').select_option
    find('select[name="pick_up_time"]').find(:xpath, 'option[2]').select_option

    click_on 'Search'

    new_row_count = all('table.table tr').count

    refute_equal first_row_count, new_row_count
  end

  test 'search the index for a single item' do
    visit root_url

    # Fill search form
    find('select[name="pick_up_borough"]').find('option', text: @trip.pick_up_borough.whole_name).select_option

    click_on 'Search'

    row_count = all('table.table tr').count

    assert_equal 2, row_count
  end

  test 'test pagination' do
    visit root_url

    first_row_count = all('table.table tr').count

    assert_operator first_row_count, :>, 25

    click_on 'Next'

    new_row_count = all('table.table tr').count

    assert_operator new_row_count, :<, 25
  end
end