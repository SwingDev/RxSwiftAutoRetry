//
//  RxSwiftExpRetryTests.swift
//  RxSwiftExpRetryTests
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
    
    func testNumberOfRetries() {
        let scheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "TestNumberOfRetriesQueue")
        var numberOfRetries = 0
        ObservableFactory.instance.createObservable()
            .retry(3, with: 0.9...1.1, scheduler: scheduler) {_ in numberOfRetries += 1}
            .subscribe()
            .disposed(by: disposeBag)
        expect(numberOfRetries).toEventually(equal(3), timeout: 40)
    }
    
    func testErrorFlow() {
        let scheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "TestCorrectErrorQueue")
        var actualError: MockError?
        let expectedErrorMessage = "Testing exponential retry"
        
        ObservableFactory.instance.createObservable(errorMessage: expectedErrorMessage)
            .retry(2, with: 0.9...1.1, scheduler: scheduler)
            .subscribe(onError: { (error) in
                actualError = error as? MockError
            })
            .disposed(by: disposeBag)
        
        expect(actualError).toEventuallyNot(beNil(), timeout: 15)
        guard let mockError = actualError, case let MockError.mockTextError(actualErrorMessage) = mockError else { return }
        expect(actualErrorMessage).to(equal(expectedErrorMessage))
    }
    
    func testRetryThread() {
        let expectedRetryQueueLabelName = "TestRetryThreadQueue"
        let scheduler = SerialDispatchQueueScheduler(internalSerialQueueName: expectedRetryQueueLabelName)
        var actualRetryQueueLabelName = "Unknown"
        
        ObservableFactory.instance.createObservable()
            .retry(1, with: 0.9...1.1, scheduler: scheduler) {_ in
                guard let queueLabelName = DispatchQueue.CurrentQueueLabelName else { return }
                actualRetryQueueLabelName = queueLabelName
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        expect(actualRetryQueueLabelName).toEventually(equal(expectedRetryQueueLabelName), timeout: 3)
    }
    
    func testFollowingRetryIntervalTimes() {
        let expectedRetryQueueLabelName = "TestFollowingRetryIntervalTimesQueue"
        let scheduler = SerialDispatchQueueScheduler(internalSerialQueueName: expectedRetryQueueLabelName)
        let marginOfError = 0.2
        let expectedIntervalTimeRanges = (1...3).map { exp(Double($0)) }
        var actualIntervalTimes = [Double]()
        var startTime: Date?
        
        ObservableFactory.instance.createObservable()
            .retry(3, with: 1.0...1.0, scheduler: scheduler) {_ in
                guard let startTime = startTime else { return }
                actualIntervalTimes += [Date().timeIntervalSince(startTime)]
            }
            .subscribe(onNext: {_ in
                startTime = Date()
            })
            .disposed(by: disposeBag)
        
        expect(actualIntervalTimes.count).toEventually(equal(3), timeout: 40)
        for (index, expectedTime) in expectedIntervalTimeRanges.enumerated(){
            expect(actualIntervalTimes[index]).to(beCloseTo(expectedTime, within: marginOfError))
        }
    }
}
