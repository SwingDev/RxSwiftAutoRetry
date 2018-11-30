Pod::Spec.new do |s|
  s.name             = 'RxSwiftAutoRetry'
  s.version          = '0.9.0'
  s.summary          = 'RxSwiftAutoyRetry allows user to retry stream after exponentiall time'

  s.homepage         = 'https://github.com/SwingDev/RxSwiftAutoRetry'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SwingDev' => 'opensource@swingdev.io' }
  s.source           = { :git => 'https://github.com/SwingDev/RxSwiftAutoRetry.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'RxSwiftAutoRetry/Source/*'
  s.dependency 'RxSwift', '~> 4.4'
end
