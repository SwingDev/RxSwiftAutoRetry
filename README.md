# RxSwiftAutoRetry

[![CI Status](https://app.bitrise.io/app/ed98584975d8f98a/status.svg?token=a_tPFWvR2HKJmI3Gv-Ew0Q)
[![Version](https://img.shields.io/cocoapods/v/RxSwiftAutoRetry.svg?style=flat)](https://cocoapods.org/pods/RxSwiftAutoRetry)
[![License](https://img.shields.io/cocoapods/l/RxSwiftAutoRetry.svg?style=flat)](https://cocoapods.org/pods/RxSwiftAutoRetry)
[![Platform](https://img.shields.io/cocoapods/p/RxSwiftAutoRetry.svg?style=flat)](https://cocoapods.org/pods/RxSwiftAutoRetry)

RxSwiftAutoRetry is an extension to [RxSwift](https://github.com/ReactiveX/RxSwift) - a well-known Reactive Swift framework.
It allows user to retry observable after exponential time. It also provides simple way to randomize time of delay.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
* iOS 8.0+
## Installation
#### From CocoaPods
[CocoaPods](https://cocoapods.org)  is a dependency manager, which simplifies to add 3rd-party libraries. To install it, add the following line to your Podfile:

```ruby
pod 'RxSwiftAutoRetry'
```
Then, you need to run below comand to install framework into your project:
```ruby
pod install
```

#### From Carthage
[Carthage](https://github.com/Carthage/Carthage) is decentralized dependency manager which allows to build dependencies...

#### From Swift Package Manager
[Swift Package Manager](https://swift.org/package-manager/) is is a tool for managing the distribution of Swift code...
## Usage
See sample project in Example/ folder.

`retryExponentially` is extension method for RxSwift framework (in case to use this method please import **RxSwift** library.)

Usually using this method looks like it:
```Swift
observable.retryExponentially(2, with: 0.9...1.1, scheduler: scheduler) { error in
//Add code
}
```

This method provides set of defaults values for parameters so there is no objection in writing:
```Swift
observable.retryExponentially()
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
