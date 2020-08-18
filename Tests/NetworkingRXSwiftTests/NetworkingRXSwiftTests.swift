//
//  File.swift
//  
//
//  Created by hamed mohammadi on 8/13/20.
//

import XCTest
import RxSwift
@testable import Networking
@testable import NetworkingRXSwift

fileprivate struct ApiConfigData {
    var APIKey:String? = "dejavuu"
}



extension ApiConfigData:ConfigDataProtocol {
    @discardableResult static func load() -> ApiConfigData {
        return ApiConfigData()
    }
    
    static func save() throws {
        
    }
}

extension ApiConfigData:NetworkConfigurable {
    var baseURL: URL {
        return URL(string: String.httpBinURLString)!
    }
    
    var headers: [String : String] {
        return ["Authorization": "Bearer \(APIKey ?? "")"]
    }
    
    var queryParameters: [String : String] {
        return [:]
    }
}


final class NetworkServiceRXSwiftTests: BaseTestCase {
    private let router = Router<ApiConfigData>()
    
    func testSimpleRXRequest() {
        struct Response:Codable {
            struct Author:Codable {
                var author:String?
                var date:String?
            }
            var slideshow:Author
        }
        
        let endPoint = EndPoint<Response>(
                  path: "/json",
                  method: .get)
        let expect = expectation(description: "request should complete")
        
        _ = router.request(with: endPoint)
            .subscribe(onSuccess: { (model) in
                XCTAssertNotNil(model.slideshow.author)
                XCTAssertNotNil(model.slideshow.date)
                expect.fulfill()
            }, onError: { (error) in
                XCTAssert(false, error.localizedDescription)
                expect.fulfill()
            })
        
        waitForExpectations(timeout: timeout)
    }
    
    static var allTests = [
        ("testSimpleRXRequest", testSimpleRXRequest),
    ]
}
