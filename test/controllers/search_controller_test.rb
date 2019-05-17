# frozen_string_literal: true

require 'test_helper'

class SearchControllerTest < ActionDispatch::IntegrationTest
  setup do
    5.times do
      FactoryBot.create(:trip)
    end

    @pick_up_borough = FactoryBot.create(:borough)
    @drop_off_borough = FactoryBot.create(:borough)
    @pick_up_day = Trip.day_of_week_options.sample(1)[1]
    @pick_up_hour = (0...24).to_a.sample(1)
  end

  test 'should get root' do
    get root_url
    assert_response :success
  end

  test 'should get root with type filters' do
    get root_url, params: { vehicle_type: 'green' }
    assert_response :success
  end

  test 'should get root with pick up location filters' do
    get root_url, params: { pick_up_borough: @pick_up_borough.id }
    assert_response :success
  end

  test 'should get root with drop off location filters' do
    get root_url, params: { drop_off_borough: @drop_off_borough.id }
    assert_response :success
  end

  test 'should get root with pick up day filters' do
    get root_url, params: { pick_up_day: @pick_up_day }
    assert_response :success
  end

  test 'should get root with pick up hour filters' do
    get root_url, params: { pick_up_hour: @pick_up_hour }
    assert_response :success
  end

  test 'should get root with pick up day & hour filters' do
    get root_url, params: { pick_up_day: @pick_up_day, pick_up_hour: @pick_up_hour }
    assert_response :success
  end

  test 'should get root with all filters' do
    get root_url, params: { vehicle_type: 'green', pick_up_borough: @pick_up_borough.id,
                            drop_off_borough: @drop_off_borough.id,
                            pick_up_day: @pick_up_day, pick_up_hour: @pick_up_hour }

    assert_response :success
  end
end
