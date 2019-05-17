# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :headless_chrome, screen_size: [1280, 1280]
end

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  [
    'headless',
    'window-size=1280x1280',
    'disable-gpu' # https://developers.google.com/web/updates/2017/04/headless-chrome
  ].each { |arg| options.add_argument(arg) }

  Capybara::Selenium::Driver.new app, browser: :chrome, options: options
end
