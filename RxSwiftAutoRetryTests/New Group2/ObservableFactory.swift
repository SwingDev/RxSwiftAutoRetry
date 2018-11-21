//
//  ObservableFactory.swift
//  RxSwiftExpRetry
//
//  Created by Krystian Bujak on 20/11/2018.
//  Copyright © 2018 SwingDev. All rights reserved.
//

import Foundation
import RxSwift

class ObservableFactory{
    static let instance = ObservableFactory()
    
    func createObservable() -> Observable<Int>{
        return Observable<Int>.create{ observer in
            observer.onNext(1)
            observer.onNext(2)
            observer.onError(MockError.mockSimpleError)
            observer.onNext(3)
            return Disposables.create()
        }
    }
    
    func createObservable(errorMessage: String) -> Observable<Int>{
        return Observable<Int>.create{ observer in
            observer.onNext(1)
            observer.onNext(2)
            observer.onError(MockError.mockTextError(errorMessage))
            observer.onNext(3)
            return Disposables.create()
        }
    }
    
    func createObservable(with nextEventsNumber: Int) -> Observable<Int>{
        return Observable<Int>.create{ observer in
            (0..<nextEventsNumber).forEach { observer.onNext($0) }
            observer.onError(MockError.mockSimpleError)
            return Disposables.create()
        }
    }
}
