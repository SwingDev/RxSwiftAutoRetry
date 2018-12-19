# RxSwiftAutoRetry

![CI Status](https://app.bitrise.io/app/ed98584975d8f98a/status.svg?token=a_tPFWvR2HKJmI3Gv-Ew0Q)
[![Version](https://img.shields.io/cocoapods/v/RxSwiftAutoRetry.svg?style=flat)](https://cocoapods.org/pods/RxSwiftAutoRetry)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/RxSwiftAutoRetry.svg?style=flat)](https://cocoapods.org/pods/RxSwiftAutoRetry)
[![Platform](https://img.shields.io/cocoapods/p/RxSwiftAutoRetry.svg?style=flat)](https://cocoapods.org/pods/RxSwiftAutoRetry)

RxSwiftAutoRetry is an extension to [RxSwift](https://github.com/ReactiveX/RxSwift) - a well-known Reactive Swift framework.
It allows user to retry observable after exponential time. It also provides simple way to randomize time of delay.

## Example

To run the example project, clone the repo, and run `pod install` from the root project directory first.

## Requirements
* iOS 8.0+
* macOS 10.9+
## Installation
### CocoaPods
[CocoaPods](https://cocoapods.org)  is a dependency manager, which simplifies adding 3rd-party libraries. To install it, add the following line to your Podfile:

```ruby
pod 'RxSwiftAutoRetry'
```
Then, you need to run below comand to install framework into your project:
```ruby
pod install
```
### Carthage
[Carthage](https://github.com/Carthage/Carthage) is decentralized dependency manager which allows you to keep your dependencies in compiled format. 
1. To install it, add following line to your Cartfile:
```ruby
github 'SwingDev/RxSwiftAutoRetry'
```
2. Next, run `carthage update`
3. On your application targets’ **Build Phases** tab, in the **Link Binary With Libraries** section, drag and drop `RxAtomic.framework`, `RxSwift.framework` and `RxSwiftAutoRetry.framework` from the Carthage/Build folder on disk.
4. On your application targets’ **Build Phases** settings tab, click the + icon and choose **New Run Script Phase**. Create a Run Script in which you specify your shell (ex: /bin/sh), add the following contents to the script area below the shell:
```
/usr/local/bin/carthage copy-frameworks
```
5. Add the paths to the frameworks you want to use under “Input Files". For example:
```
$(SRCROOT)/Carthage/Build/<platform>/RxAtomic.framework
$(SRCROOT)/Carthage/Build/<platform>/RxSwift.framework
$(SRCROOT)/Carthage/Build/<platform>/RxSwiftAutoRetry.framework
```
### Swift Package Manager
[Swift Package Manager](https://swift.org/package-manager/) is is a tool for managing the distribution of Swift code and integrating it into compiler.

**It only works with macOS.**

Add dependency to your `Package.swift` file:
``` swift
dependencies: [
.package(url: "https://github.com/SwingDev/RxSwiftAutoRetry.git", from: "0.9"))
]
```
Then, run below command:
```ruby
pod install
```
## Usage
See sample project in [Example](ExampleApp/) folder.

`retryExponentially` is extension method for RxSwift framework (in case to use this method please import **RxSwift** library.)

Usually using this method looks like it:
```Swift
observable.retryExponentially()
```
This method provides set of default values for parameters so its behavior can be customized:
```Swift
observable.retryExponentially(2, with: 0.9...1.1, scheduler: scheduler) { error in
//Add code
}
```

##### Parameters
* **maxAttemptCount** - Maximum number of times to repeat the sequence.
* **jitter** - Multiplier which randomize delay time. Randomizing value is chosen from given range.
* **scheduler** - Scheduler on which the delay will be conducted
* **onRetry** - Action which will be invoked after delay on every retry. This is optional parameter.

##### Default values
* **maxAttemptCount**:  `3`
* **jitter**: `0.9...1.1`
* **scheduler**: `ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())`
* **onRetry**: `nil`
## License

RxSwiftAutoRetry is available under the MIT license. See the LICENSE file for more info.
