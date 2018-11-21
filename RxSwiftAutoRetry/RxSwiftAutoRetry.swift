import Foundation
import RxSwift

extension ObservableType{
    public func retry(_ trial: Int, with jitter: ClosedRange<Double>, scheduler: SchedulerType, onRetry: ((Error) -> ())? = nil) -> Observable<E>{
        return retry(1, maxTrial: trial, jitter: jitter, scheduler: scheduler, onRetry: onRetry)
    }
    
    private func retry(_ actualTrial: Int, maxTrial: Int, jitter: ClosedRange<Double>, scheduler: SchedulerType, onRetry: ((Error) -> ())? = nil) -> Observable<E>{
        guard actualTrial > 0 else { return Observable.empty() }
        
        return catchError({ error -> Observable<E> in
            guard actualTrial <= maxTrial else { return Observable.error(error) }
            
            let delay = exp(Double(actualTrial) * Double.random(in: jitter))
            return Observable<Void>.just(()).delaySubscription(delay, scheduler: scheduler).do(onNext: {_ in
                onRetry?(error)
            })
            .flatMap { _ in
                return self.retry(actualTrial + 1, maxTrial: maxTrial, jitter: jitter, scheduler: scheduler, onRetry: onRetry)
            }
        })
    }
}
