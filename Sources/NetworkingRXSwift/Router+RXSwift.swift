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
    -> Driver<Result<T,NetworkError>>
}

extension Router:RXNetworkRouter {
    public func request<T>(with endpoint: EndPoint<T>) -> Driver<Result<T,NetworkError>> where T : Decodable {
        return Observable.create { [unowned self] observer in
            var cancelable:NetworkCancellable? = nil
            cancelable = self.request(with: endpoint, onChangeCancelable: { (cnclbl:NetworkCancellable?) in
                cancelable = cnclbl
            }) { (result) in
                observer.onNext(result)
//                observer.o
//                switch result {
//                case .success(let model):
//
//                case .failure(let error):
//                    observer.onError(error)
//                }
            }
            
            return Disposables.create {
                cancelable?.cancel()
            }
        }.asDriver(onErrorJustReturn: Result.failure(NetworkError.notConnected))
            
            
        
    }
    
    
}
