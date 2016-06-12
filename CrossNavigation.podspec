Pod::Spec.new do |s|
  s.name             = "CrossNavigation"
  s.version          = "1.2.0"
  s.summary          = "Any side navigation."
  s.description      = <<-DESC
                       if you inherit your view controllers from CNViewController, CNNavigationController, or CNTabBarController, you'll be able to push them to the stack not just to right side (as you do if you use UINavigationController), but to any of four: left, top, right, bottom. Supports autorotations.
                       DESC
  s.homepage         = "https://github.com/artemstepanenko/CrossNavigation"
  s.license          = 'MIT'
  s.author           = { "Artem Stepanenko" => "artem.stepanenko.1@gmail.com" }
  s.source           = { :git => "https://github.com/artemstepanenko/CrossNavigation.git", :tag => "release/v1.2.0" }
  s.social_media_url = 'http://stackoverflow.com/users/1090309/artem-stepanenko'

  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.source_files = 'CrossNavigation/**/*.{h,m}'

  s.framework    = 'UIKit'
  
end
