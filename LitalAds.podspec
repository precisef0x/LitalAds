Pod::Spec.new do |s|
    s.name             = 'LitalAds'
    s.version          = '0.9.5'
    
    s.summary          = 'LitalAds - Ads for Lital'
    s.description      = 'Personalized Lital ads with minigames'
    
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
