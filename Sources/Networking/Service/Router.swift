//
//  NetworkService.swift
//  NetworkLayer
//
//  Created by Habibollah Mohammadi on 2018/08/05.
//  Copyright © 2020 Habibollah Mohammadi. All rights reserved.
//

import Foundation

//public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()



public protocol NetworkRouter: class {
    associatedtype ConfigData: ConfigDataProtocol
    init(interceptors:[InterceptorProtocol]?)
    //    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) -> RequestCancelable?
}

public protocol NetworkCancellable {
    func cancel()
}
extension URLSessionTask:NetworkCancellable {}

public protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

public class Router<ConfigData:ConfigDataProtocol & NetworkConfigurable>: NetworkRouter{
    
    public typealias ConfigData = ConfigData
    
    public typealias CompletionHandler<T> = (Result<T, NetworkError>) -> Void
    
    
    private let interceptors:[InterceptorProtocol]?
    
    public required init(interceptors: [InterceptorProtocol]? = nil) {
        self.interceptors = interceptors
    }
    
    
    private struct MutableState {
//        var requestQueue:[EndPoint] = []
//        var currentInterceptor:InterceptorProtocol?
        var configData = ConfigData.load()
    }
    
    
    let queue = DispatchQueue(label: "org.alamofire.authentication.inspector")
    
    @Protected
    private var mutableState = MutableState()
    //    public
    
    //    public func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) -> RequestCancelable? {
    //           let session = URLSession.shared
    //           var task: URLSessionTask? = nil
    //           do {
    //               let request = try self.buildRequest(from: route)
    //               NetworkLogger.log(request: request)
    //               task = session.dataTask(with: request, completionHandler: { data, response, error in
    //                   completion(data, response, error)
    //               })
    //           }catch {
    //               completion(nil, nil, error)
    //           }
    //           task?.resume()
    //           return task
    //       }
    
//    @discardableResult
    public func request<T: Decodable>(
        with endpoint: EndPoint<T>,
        onChangeCancelable:((NetworkCancellable?)->())? = nil,
        completion: @escaping CompletionHandler<T>)
        -> NetworkCancellable?  {
//    public func request<T: Decodable>(
//        with endpoint: EndPoint<T>,
//        onChangeCancelable:((NetworkCancellable?)->())? = nil,
//        completion: @escaping CompletionHandler<T>)
//        -> NetworkCancellable?
//    {
        var request:URLRequest
        do{
            try checkInterceptorValidation()
        } catch {
            completion(.failure(NetworkError.generic(error)))
            return nil
        }
        let res = $mutableState.read { mutableState -> (URLRequest?,Error?) in
            var request:URLRequest? = nil
            var err:Error? = nil
            do{
                request = try endpoint.urlRequest(with: mutableState.configData)
            } catch {
                err = error
            }
            return (request, err)
        }
        guard res.0 != nil else {
            completion(.failure(NetworkError.generic(res.1!)))
            return nil
        }
        request = res.0!
        
        NetworkLogger.log(request: request)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {[weak self] data, response, error in
            guard let SELF = self else {
                completion(.failure(NetworkError.notConnected))
                return
            }
            var errorDueToInterceptorInvalidation = false
            if let error = error {
                SELF.$mutableState.read { mutableState in
                    for intcptr in SELF.interceptors ?? []{
                        if intcptr.isErrorMine(configData: mutableState.configData,
                                               error: error) {
                            errorDueToInterceptorInvalidation = true
                            intcptr.setNeedRevalidate()
                        }
                    }
                }
            }
            
            if errorDueToInterceptorInvalidation {
                onChangeCancelable?(
                    SELF.request(with: endpoint,
                                 onChangeCancelable: onChangeCancelable,
                                 completion: completion))
                
            }
            let result: Result<T, NetworkError> = SELF.decode(data: data, decoder: endpoint.responseDecoder)
            completion(result)
        })
        
        task.resume()
        return task
    }
    
    private func checkInterceptorValidation() throws{
        let error =  $mutableState.write { mutableState -> Error? in
            for interceptor in self.interceptors ?? [] {
                if interceptor.needRevalidate() {
                    let group = DispatchGroup()
                    group.enter()
                    var error:Error? = nil
                    interceptor
                        .revalidate(configData: &mutableState.configData)
                        { result in
                            if case InterceptorResult.failure(let err) =  result {
                                error = err
                            }
                            group.leave()
                    }
                    group.wait()
                    if error != nil {
                        return error
                    }
                }
            }
            return nil
        }
        if error != nil {
            throw error!
        }
    }
    
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Result<T, NetworkError> {
        do {
            guard let data = data else { return .failure(NetworkError.noData) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
//            self.errorLogger.log(error: error)
            return .failure(NetworkError.encodingFailed)
        }
    }
}
