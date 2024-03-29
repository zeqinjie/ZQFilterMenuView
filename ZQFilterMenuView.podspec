#
# Be sure to run `pod lib lint ZQFilterMenuView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZQFilterMenuView'
  s.version          = '0.1.6'
  s.summary          = 'ZQFilterMenuView 筛选器'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zeqinjie/ZQFilterMenuView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhengzeqin' => '1875193628@qq.com' }
  s.source           = { :git => 'https://github.com/zeqinjie/ZQFilterMenuView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ZQFilterMenuView/Classes/**/*'
  
   s.resource_bundles = {
     'ZQFilterMenuView' => ['ZQFilterMenuView/Assets/*.png']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # 依赖库
  s.dependency 'Masonry'
  s.dependency 'ZQFoundationKit'
end
