//
//  RxSwiftAutoRetryTests.swift
//  RxSwiftAutoRetryTests
//
//  Created by Krystian Bujak on 20/11/2018.
//  Copyright © 2018 SwingDev. All rights reserved.
//

import XCTest
import RxSwift
import Nimble
@testable import RxSwiftAutoRetry

class RxSwiftAutoRetryTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    func testNumberOfRetries0() {
        let scheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
        var numberOfRetries = 0
        ObservableFactory.instance.createObservable()
            .retryExponentially(0, with: 0.9...1.1, scheduler: scheduler) {_ in numberOfRetries += 1}
            .subscribe()
            .disposed(by: disposeBag)
        expect(numberOfRetries).toEventually(equal(0), timeout: 3)
    }
    
    func testNumberOfRetries1() {
        let scheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
        var numberOfRetries = 0
        ObservableFactory.instance.createObservable()
            .retryExponentially(1, with: 0.9...1.1, scheduler: scheduler) {_ in numberOfRetries += 1}
            .subscribe()
            .disposed(by: disposeBag)
        expect(numberOfRetries).toEventually(equal(1), timeout: 4)
    }
    
    func testNumberOfRetries2() {
        let scheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
        var numberOfRetries = 0
        ObservableFactory.instance.createObservable()
            .retryExponentially(2, with: 0.9...1.1, scheduler: scheduler) {_ in numberOfRetries += 1}
            .subscribe()
            .disposed(by: disposeBag)
        expect(numberOfRetries).toEventually(equal(2), timeout: 15)
    }
    
    func testNumberOfRetries3() {
        let scheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
        var numberOfRetries = 0
        ObservableFactory.instance.createObservable()
            .retryExponentially(3, with: 0.9...1.1, scheduler: scheduler) {_ in numberOfRetries += 1}
            .subscribe()
            .disposed(by: disposeBag)
        expect(numberOfRetries).toEventually(equal(3), timeout: 40)
    }
    
    func testErrorFlow() {
        let scheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
        var actualError: MockError?
        let expectedErrorMessage = "Testing exponential retry error flow"
        
        ObservableFactory.instance.createObservable(errorMessage: expectedErrorMessage)
            .retryExponentially(2, with: 0.9...1.1, scheduler: scheduler)
            .subscribe(onError: { (error) in
                actualError = error as? MockError
            })
            .disposed(by: disposeBag)
        
        expect(actualError).toEventuallyNot(beNil(), timeout: 15)
        guard let mockError = actualError,
            case let MockError.mockTextError(actualErrorMessage) = mockError else { return }
        expect(actualErrorMessage).to(equal(expectedErrorMessage))
    }
    
    func testRetryThread() {
        let expectedRetryQueueLabelName = "TestRetryThreadQueue"
        let queue = DispatchQueue(label: expectedRetryQueueLabelName, qos: .background)
        let scheduler = ConcurrentDispatchQueueScheduler(queue: queue)
        var actualRetryQueueLabelName = "Unknown"
        
        ObservableFactory.instance.createObservable()
            .retryExponentially(1, with: 0.9...1.1, scheduler: scheduler) {_ in
                guard let queueLabelName = DispatchQueue.CurrentQueueLabelName else { return }
                actualRetryQueueLabelName = queueLabelName
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        expect(actualRetryQueueLabelName).toEventually(equal(expectedRetryQueueLabelName), timeout: 3)
    }
    
    func testFollowingRetryIntervalTimes() {
        let scheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
        let marginOfError = 0.2
        let expectedIntervalTimeRanges = (1...3).map { exp(Double($0)) }
        var actualIntervalTimes = [Double]()
        var startTime: Date?
        
        ObservableFactory.instance.createObservable()
            .retryExponentially(3, with: 1.0...1.0, scheduler: scheduler) {_ in
                guard let startTime = startTime else { return }
                actualIntervalTimes += [Date().timeIntervalSince(startTime)]
            }
            .subscribe(onNext: {_ in
                startTime = Date()
            })
            .disposed(by: disposeBag)
        
        expect(actualIntervalTimes.count).toEventually(equal(3), timeout: 40)
        for (index, expectedTime) in expectedIntervalTimeRanges.enumerated() {
            expect(actualIntervalTimes[index]).to(beCloseTo(expectedTime, within: marginOfError))
        }
    }
    
    func testObjectReleaseInRetryActionClosure() {
        weak var weakTestObject: Observable<Int>?
        
        let _ = {
            autoreleasepool(invoking: {
                let scheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
                
                let obs = ObservableFactory.instance.createObservable()
                weakTestObject = obs
                obs
                    .retryExponentially(1, scheduler: scheduler)
                    .subscribe(onNext: {_ in print("Next") }, onError: {_ in print("Error") },
                        onCompleted: { print("Completed") }, onDisposed: {print("Disposed")}
                    )
                    .disposed(by: disposeBag)
            })
            
        }()
        expect(weakTestObject).toEventually(beNil(),timeout: 5)
    }
}
