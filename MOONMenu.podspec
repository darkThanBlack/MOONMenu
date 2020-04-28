#
# Be sure to run `pod lib lint MOONMenu.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MOONMenu'
  s.version          = '0.2.0'
  s.summary          = 'A bundle of debug UI that looks like iOS system AssistiveTouch.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A bundle of debug UI that looks like iOS system AssistiveTouch.
一组仿照系统“便捷访问”浮窗按钮样式设计的 UI 控件，可以用于代码调试。
                       DESC

  s.homepage         = 'https://github.com/darkThanBlack/MOONMenu'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'darkThanBlack' => '331614794@qq.com' }
  s.source           = { :git => 'https://github.com/darkThanBlack/MOONMenu.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.platform = :ios
  s.swift_version = '4.0', '5.0'
  s.ios.deployment_target = '10.0'

  s.source_files = 'MOONMenu/Classes/**/*'
  
#  s.resource = "MOONMenu/Assets/*.bundle"
    s.resource_bundles = {
     'MOONMenuSkin' => ['MOONMenu/Assets/*.png']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
