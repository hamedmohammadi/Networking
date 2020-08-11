//
//  Interceptor.swift
//  NetworkLayer
//
//  Created by hamed mohammadi on 8/8/20.
//  Created by Habibollah Mohammadi on 2018/08/05.
//  Copyright © 2020 Habibollah Mohammadi. All rights reserved.
//

import Foundation

public enum InterceptorError:Error {
    case revalidationFailed
    case network(Error)
}
public protocol ConfigDataProtocol:Codable {
    
    @discardableResult static func load() -> Self
    
    static func save() throws
}

public enum InterceptorResult {
    case success
    case failure(InterceptorError)
}

public protocol InterceptorProtocol{
    func needRevalidate()->Bool
    func setNeedRevalidate()
    func isErrorMine<T:ConfigDataProtocol>(configData:T, error:Error) -> Bool
    func revalidate<T:ConfigDataProtocol>(configData:inout T, completion:(InterceptorResult)->())
}
