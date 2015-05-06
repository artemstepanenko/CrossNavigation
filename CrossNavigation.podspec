Pod::Spec.new do |s|
  s.name             = "CrossNavigation"
  s.version          = "1.1.3.1"
  s.summary          = "Any side navigation."
  s.description      = <<-DESC
                       if you inherit your view controllers from CNViewController, you'll be able to push them to the stack not just to right side (as you do if you use UINavigationController), but to any of four: left, top, right, bottom. Supports autorotations.
                       DESC
  s.homepage         = "https://github.com/artemstepanenko/CrossNavigation"
  s.license          = 'MIT'
  s.author           = { "Artem Stepanenko" => "artem.stepanenko.1@gmail.com" }
  s.source           = { :git => "https://github.com/artemstepanenko/CrossNavigation.git", :tag => "release/v1.1.3.1" }
  s.social_media_url = 'http://stackoverflow.com/users/1090309/artem-stepanenko'

  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'CrossNavigation/**/*.{h,m}'
  s.public_header_files = 'CrossNavigation/*.h'

  s.framework    = 'UIKit'
  
end
