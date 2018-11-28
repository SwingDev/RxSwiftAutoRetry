Pod::Spec.new do |s|
  s.name             = 'RxSwiftAutoRetry'
  s.version          = '1.0.0'
  s.summary          = 'A short description of RxSwiftAutoRetry.'

  s.homepage         = 'https://github.com/SwingDev/RxSwiftAutoRetry'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SwingDev' => 'SwingDev email' }
  s.source           = { :git => 'https://github.com/SeingDev/RxSwiftAutoRetry.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'RxSwiftAutoRetry/Source/*'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'RxSwift', '~> 4.4'
end
