import Foundation
import RxSwift

extension ObservableType {
    /**
     
     Repeats the source observable sequence until given attempts number. Each reapet is delayed exponentially.
 
     - parameter maxAttemptCount: Maximum number of times to repeat the sequence.
     - parameter jitter: Range allowing to randomize delay time
     - parameter scheduler: Scheduler on which the delay will be conducted
     - parameter onRetry: Action which will be invoked after delay on every retry
    */
    public func retryExponentially(_ maxAttemptCount: Int = 3,
                      with jitter: ClosedRange<Double> = 0.9...1.1,
                      scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()),
                      onRetry: ((Error) -> Void)? = nil) -> Observable<E> {
        guard maxAttemptCount > 0 else { return Observable.empty() }
        return retryExponentially(1, maxAttemptCount: maxAttemptCount, jitter: jitter, scheduler: scheduler, onRetry: onRetry)
    }

    private func retryExponentially(_ actualAttempt: Int,
                       maxAttemptCount: Int,
                       jitter: ClosedRange<Double>,
                       scheduler: SchedulerType,
                       onRetry: ((Error) -> Void)? = nil) -> Observable<E> {
        
        return catchError({ error -> Observable<E> in
            guard actualAttempt <= maxAttemptCount else { return Observable.error(error) }
            
            let delay = exp(Double(actualAttempt) * Double.random(in: jitter))
            return Observable<Void>.just(())
                .delaySubscription(delay, scheduler: scheduler)
                .do(onNext: {_ in
                    onRetry?(error)
                })
                .flatMap { _ in
                    return self.retryExponentially(actualAttempt + 1,
                                                   maxAttemptCount: maxAttemptCount,
                                                   jitter: jitter,
                                                   scheduler: scheduler,
                                                   onRetry: onRetry)
            }
        })
    }
}
