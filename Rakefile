require 'fileutils'
require 'optparse'
require 'json'
require 'ostruct'

config = JSON.parse(File.read('package.json'), {object_class: OpenStruct})

EXAMPLES = 'Examples'
PROJECT = 'Segment-MoEngage.xcodeproj'
TUIST = File.join(`brew --prefix`.strip, 'bin', 'tuist')

file TUIST do
  system('brew install tuist', out: STDOUT, exception: true)
end

directory config.xcframework.workspace
file config.xcframework.workspace => TUIST do
  Dir.chdir(EXAMPLES) do
    system('tuist generate --no-open', out: STDOUT, exception: true)
  end
end

directory PROJECT
file PROJECT => TUIST do
  Dir.chdir(EXAMPLES) do
    system('tuist install', out: STDOUT, exception: true)
  end
end

desc 'Setup project for running'
task :setup => [TUIST, PROJECT] do |t|
  Dir.chdir(EXAMPLES) do
    system('tuist generate --no-open', out: STDOUT, exception: true)
  end
end

desc <<~DESC
  Build XCFramework zips
  pass environment variables:
    GITHUB_TOKEN: The token for GitHub authentication
    MO_CERTIFICATE_IDENTITY: The certificate identity for signing xcframeworks.
DESC
task :xcframework => [PROJECT, config.xcframework.workspace] do |t, args|
  require 'net/http'
  common_script = URI('https://raw.githubusercontent.com/moengage/sdk-automation-scripts/refs/heads/master/scripts/release/ios/common.rb')
  common_req = Net::HTTP::Get.new(common_script.request_uri)
  common_req['Authorization'] = "Bearer #{ENV['GITHUB_TOKEN']}"
  common_http = Net::HTTP.new(common_script.host, common_script.port)
  common_http.use_ssl = true
  common_res = common_http.request(common_req)
  xcframework_script = URI('https://raw.githubusercontent.com/moengage/sdk-automation-scripts/refs/heads/master/scripts/release/ios/xcframework.rb')
  xcframework_req = Net::HTTP::Get.new(xcframework_script.request_uri)
  xcframework_req['Authorization'] = "Bearer #{ENV['GITHUB_TOKEN']}"
  xcframework_http = Net::HTTP.new(xcframework_script.host, xcframework_script.port)
  xcframework_http.use_ssl = true
  xcframework_res = xcframework_http.request(xcframework_req)
  script = xcframework_res.body
  script.gsub!("require_relative 'common'", "\n#{common_res.body}\n")
  eval(script)
end

desc <<~DESC
  Run tests
DESC
task :test do |t, args|
  require_relative 'Utilities/test'
  run_tests
end
