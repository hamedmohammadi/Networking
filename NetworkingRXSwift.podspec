#
# Be sure to run `pod lib lint Networking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NetworkingRXSwift'
  s.version          = '0.9.9'
  s.summary          = 'A short description of Networking.'
  s.swift_version = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-EOS
Rest API Support.
a. RX Support.
b. Supported by swift package and CocoaPod in progress....
c. Support for JWT and Auto refresh support.
d. Object Mapping support.
e. I put some tests in this library but more tests needed. (in progress...).
f. Multi API is fully supported with its own authorization processes.
EOS

  s.homepage         = 'https://github.com/hamedmohammadi/Networking'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hamedmohammadi' => 'hamed.nova@gmail.com' }
  s.source           = { :git => 'https://github.com/hamedmohammadi/Networking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'

  s.source_files     = 'Sources/NetworkingRXSwift/**/*'
  
  # s.resource_bundles = {
  #   'Networking' => ['Networking/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Networking', '~> 0.9'
  s.dependency 'RxSwift', '~> 5'
  s.dependency 'RxCocoa', '~> 5'


end
