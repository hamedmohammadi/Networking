//
//  Interceptor.swift
//  NetworkLayer
//
//  Created by Habibollah Mohammadi on 2018/08/05.
//  Copyright © 2020 Habibollah Mohammadi. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
    case encodingFailed
    case noData
}

// MARK: - NetworkError extension

extension NetworkError {
    public var isNotFoundError: Bool { return hasStatusCode(404) }
    
    public func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .error(code, _):
            return code == codeError
        default: return false
        }
    }
}

