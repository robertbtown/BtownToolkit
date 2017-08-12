Pod::Spec.new do |s|
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.name             = 'BtownToolkit'
  s.version          = '0.1.7'
  s.summary          = 'This toolkit simplifies the lives for developers by supplying easy to use and components and tools needed in our everyday code creation.'

  s.description      = <<-DESC
                      This toolkit tries to simplify the lives for app developers by supplying easy to use and feature-rich components and tools that we all need in our everyday code creation. The aim is to continuously add on more components and features to the toolkit as soon as a need for something new is discovered.
                       DESC

  s.homepage         = 'https://github.com/robertbtown/BtownToolkit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Robert Magnusson' => 'robert@btown.se' }
  s.source           = { :git => 'https://github.com/robertbtown/BtownToolkit.git', :tag => "#{s.version}" }

  s.source_files = 'BtownToolkit/Classes/**/*'

  s.dependency 'PureLayout', '~> 3.0'
  s.dependency 'AngleGradientLayer', '~> 1.2'

  s.frameworks = 'UIKit'
end
