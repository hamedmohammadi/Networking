//
//  Interceptor.swift
//  NetworkLayer
//
//  Created by Habibollah Mohammadi on 2018/08/05.
//  Copyright © 2020 Habibollah Mohammadi. All rights reserved.
//

import Foundation

// MARK: - Response Decoders
public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

public class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    public init() { }
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}

public class RawDataResponseDecoder: ResponseDecoder {
    public init() { }

    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(codingPath: [CodingKeys.default], debugDescription: "Expected Data type")
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}
