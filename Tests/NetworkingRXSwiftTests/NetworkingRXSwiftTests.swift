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
        var event:Event<Response>? = nil
        _ = router.request(with: endPoint).subscribe { (evt:Event<Response>) in
            event = evt
            expect.fulfill()
        }
        waitForExpectations(timeout: timeout)
        XCTAssertNotNil(event)
        switch event! {
        case .next(let model):
            XCTAssertNotNil(model.slideshow.author)
            XCTAssertNotNil(model.slideshow.date)
        case .error(let error):
            XCTAssert(false, error.localizedDescription)
        default:
            ()
        }
    }
    static var allTests = [
        ("testSimpleRXRequest", testSimpleRXRequest),
    ]
}
