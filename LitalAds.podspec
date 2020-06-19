#
# Be sure to run `pod lib lint LitalAds.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LitalAds'
  s.version          = '0.9.0'
  
  s.summary          = 'LitalAds - Ads for Lital'
  s.description      = 'Personalized ads with Lital with minigames'

  s.homepage         = 'https://github.com/precisef0x/LitalAds'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ilia Kambarov' => 'ads@f0x.pw' }
  s.source           = { :git => 'https://github.com/precisef0x/LitalAds.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '10.0'
  s.platform = :ios, "10.0"
  s.swift_version = "5.0"
  
  s.source_files = 'LitalAds/Classes/**/*'
  s.resources = ['LitalAds/Media.xcassets', 'LitalAds/LitalAds.storyboard', 'Pod/**/*.{lproj,storyboard}']
  s.frameworks = 'UIKit', 'GameKit', 'AdSupport', 'Security'
end
