//
//  Interceptor.swift
//  NetworkLayer
//
//  Created by Habibollah Mohammadi on 2018/08/05.
//  Copyright © 2020 Habibollah Mohammadi. All rights reserved.
//

import Foundation

public enum NetworkError: Error,Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (NetworkError.error(statusCode: let lStatusCode, data: let lData), NetworkError.error(statusCode: let rStatusCode, data: let rData)):
            guard lStatusCode == rStatusCode else {
                return false
            }
            switch (lData, rData) {
            case (.none, .none):
                return true
            case (.some(let ldata), .some(let rdata)):
                return ldata == rdata
            default:
                return false
            }
        case (NetworkError.notConnected, NetworkError.notConnected):
            return true
        case (NetworkError.cancelled, NetworkError.cancelled):
            return true
        case (NetworkError.generic(let lError), NetworkError.generic(let rError)):
            return (lError as NSError) == (rError as NSError)
        case (NetworkError.urlGeneration, NetworkError.urlGeneration):
            return true
        case (NetworkError.encodingFailed, NetworkError.encodingFailed):
            return true
        case (NetworkError.noData, NetworkError.noData):
            return true
        default :
            return false
        }
    }
    
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

