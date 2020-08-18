//
//  File.swift
//  
//
//  Created by hamed mohammadi on 8/13/20.
//

import Foundation
import RxSwift
import RxCocoa
import Networking

public protocol RXNetworkRouter:NetworkRouter {
    func request<T: Decodable>(with endpoint: EndPoint<T>)
        -> Single<T>
}

extension Router:RXNetworkRouter {
    public func request<T>(with endpoint: EndPoint<T>) -> Single<T> where T : Decodable {
        Single.create { (single) -> Disposable in
            var cancelable:NetworkCancellable? = nil
            cancelable = self.request(with: endpoint, onChangeCancelable: { (cnclbl:NetworkCancellable?) in
                cancelable = cnclbl
            }) { (result) in
                switch result {
                case .success(let model):
                    single(.success(model))
                case .failure(let error):
                    single(.error(error))
                }
            }
            
            return Disposables.create {
                cancelable?.cancel()
            }
        }
        
        //        return Observable.create { [unowned self] observer in
        //            var cancelable:NetworkCancellable? = nil
        //            cancelable = self.request(with: endpoint, onChangeCancelable: { (cnclbl:NetworkCancellable?) in
        //                cancelable = cnclbl
        //            }) { (result) in
        //                observer.onNext(result)
        //            }
        //
        //            return Disposables.create {
        //                cancelable?.cancel()
        //            }
        //        }.asDriver(onErrorJustReturn: Result.failure(NetworkError.notConnected))
    } 
}
