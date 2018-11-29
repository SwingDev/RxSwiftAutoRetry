import Foundation
import RxSwift

extension Observable {
    /*/**
     
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
                .delay(delay, scheduler: scheduler)
                .do(onNext: {_ in onRetry?(error) })
                .flatMap { [weak self] (_) -> Observable<Element> in
                    guard let `self` = self else { return Observable<Element>.empty() }
                    return self.retryExponentially(actualAttempt + 1,
                                                   maxAttemptCount: maxAttemptCount,
                                                   jitter: jitter,
                                                   scheduler: scheduler,
                                                   onRetry: onRetry)
            }
        })
    }
 */
}

extension ObservableType {
    public func retryExponentially(_ maxAttemptCount: Int = 3,
                                   with jitter: ClosedRange<Double> = 0.9...1.1,
                                   scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()),
                                   onRetry: ((Error) -> Void)? = nil) -> Observable<E> {
        return Observable.create({
            let disposable = SerialDisposable()
            self.handleObserver(observer: $0,
                                trial: 0,
                                maxAttemptCount: maxAttemptCount,
                                disposable: disposable,
                                with: jitter,
                                scheduler: scheduler,
                                onRetry: onRetry)
            return disposable
        })
    }

    private func handleObserver(observer: AnyObserver<E>,
                                trial: Int,
                                maxAttemptCount: Int,
                                disposable: SerialDisposable,
                                with jitter: ClosedRange<Double>,
                                scheduler: SchedulerType,
                                onRetry: ((Error) -> Void)?) {
        let delay = exp(Double(trial) * Double.random(in: jitter))
        disposable.disposable = self
            .delaySubscription(delay, scheduler: scheduler)
            .subscribe({ event in
            switch event {
            case .next(let element): observer.onNext(element)
            case .completed: observer.onCompleted()
            case .error(let error):
                guard trial < maxAttemptCount else {
                    observer.onError(error)
                    return
                }
                onRetry?(error)
                self.handleObserver(observer: observer,
                                    trial: trial + 1,
                                    maxAttemptCount: maxAttemptCount,
                                    disposable: disposable,
                                    with: jitter,
                                    scheduler: scheduler,
                                    onRetry: onRetry)
            }
        })
        
    }
}
