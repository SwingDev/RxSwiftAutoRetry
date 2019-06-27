Pod::Spec.new do |s|
  s.name             = 'RxSwiftAutoRetry'
  s.version          = '0.9.1'
  s.summary          = 'RxSwiftAutoRetry allows user to retry stream after exponential time'
  s.swift_version    = '5.0'

  s.homepage         = 'https://github.com/SwingDev/RxSwiftAutoRetry'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Krystian Bujak' => 'krystian.bujak@swingdev.io' }
  s.source           = { :git => 'https://github.com/SwingDev/RxSwiftAutoRetry.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'Source/*.swift'
  s.dependency 'RxSwift', '~> 5.0'
end
