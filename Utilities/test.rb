require 'fileutils'
require 'json'
require 'ostruct'

# Run CocoaPods linting verifying build and Unit tests for each framework.
def run_tests
  # get device to test
  devices = JSON.parse(`xcrun simctl list --json devices available`.strip!)['devices'].flat_map do |runtime, devices|
    devices.map do |device|
      device['runtime'] = runtime
      device
    end
  end

  ios_device = devices.find do |device|
    device['runtime'].include?('iOS')
  end

  xcodebuild = "xcodebuild clean build test -configuration Debug "
  ios_command = "#{xcodebuild} -scheme \"Segment-MoEngage\" -destination 'id=#{ios_device['udid']}'"

  # build and test
  puts "::group::Checking for iOS"
  derived_data = File.expand_path('~/Library/Developer/Xcode/DerivedData')
  FileUtils.rm_rf(derived_data) if File.directory?(derived_data)
  system(ios_command, out: STDOUT, exception: true)
  puts "::endgroup::"
end
