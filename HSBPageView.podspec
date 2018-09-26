#
# Be sure to run `pod lib lint HSBPageView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HSBPageView'
  s.version          = '0.0.1'
  s.summary          = 'HSBPageView is Paging View.'
  s.swift_version    = '4.2'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
HSBPageView simple Paging View. support delegate and datasource.
                       DESC

  s.homepage         = 'https://github.com/hsb9kr/HSBPageView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Red' => 'hsb9kr@gmail.com' }
  s.source           = { :git => 'https://github.com/hsb9kr/HSBPageView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HSBPageView/Classes/*.swift'
  
  # s.resource_bundles = {
  #   'HSBPageView' => ['HSBPageView/Assets/*.png']
  # }

  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
