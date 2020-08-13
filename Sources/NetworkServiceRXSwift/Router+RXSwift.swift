//
//  File.swift
//  
//
//  Created by hamed mohammadi on 8/13/20.
//

import Foundation
import RxSwift
import Networking

public protocol RXNetworkRouter:NetworkRouter {
    func request<T: Decodable>(with endpoint: EndPoint<T>)
    -> Observable<T>
}

extension Router:RXNetworkRouter {
    public func request<T>(with endpoint: EndPoint<T>) -> Observable<T> where T : Decodable {
        return Observable.create { [unowned self] observer in
            var cancelable:NetworkCancellable? = nil
            cancelable = self.request(with: endpoint, onChangeCancelable: { (cnclbl:NetworkCancellable?) in
                cancelable = cnclbl
            }) { (result) in
                switch result {
                case .success(let model):
                    observer.onNext(model)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                cancelable?.cancel()
            }
        }
            
            
        
    }
    
    
}
