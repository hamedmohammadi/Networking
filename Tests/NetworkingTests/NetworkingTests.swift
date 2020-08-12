import XCTest
@testable import Networking

final class NetworkingTests: BaseTestCase {
    func testURLEncoding() {
        guard let url = URL(string: "https://www.google.com/") else {
            XCTAssertTrue(false, "Could not instantiate url")
            return
        }
        var urlRequest = URLRequest(url: url)
        let parameters: [String:String] = [
            "UserID": "1",
            "Name": "Malcolm",
            "Email": "malcolm@network.com",
            "IsCool": "true"
        ]
        
        do {
            let endpoint = EndPoint<Data>(path: "https://www.google.com/",
                                          isFullPath: true,
                                          method: .get,
                                          queryParameters: parameters)
            try urlRequest = endpoint.urlRequest()
            guard let fullURL = urlRequest.url else {
                XCTAssertTrue(false, "urlRequest url is nil.")
                return
            }
            
            let expectedURL = "https://www.google.com/?IsCool=true&Name=Malcolm&UserID=1&Email=malcolm@network.com"
            XCTAssertEqual(fullURL.absoluteString.sorted(), expectedURL.sorted())
        }catch {
            XCTAssertTrue(false, error.localizedDescription)
        }
    }
    
    func testHearders() {
        guard let url = URL(string: "https://www.google.com/") else {
            XCTAssertTrue(false, "Could not instantiate url")
            return
        }
        var urlRequest = URLRequest(url: url)
        let parameters: [String:String] = [
            "UserID": "1",
            "Name": "Malcolm",
            "Email": "malcolm@network.com",
            "IsCool": "true"
        ]
        
        do {
            let endpoint = EndPoint<Data>(path: "https://www.google.com/",
                                          isFullPath: true,
                                          method: .get,
                                          headerParamaters: parameters)
            try urlRequest = endpoint.urlRequest()
            
            
            XCTAssertEqual(urlRequest.allHTTPHeaderFields, parameters)
        }catch {
            XCTAssertTrue(false, error.localizedDescription)
        }
    }
    
    func testJsonBodyParameters() {
        guard let url = URL(string: "https://www.google.com/") else {
            XCTAssertTrue(false, "Could not instantiate url")
            return
        }
        var urlRequest = URLRequest(url: url)
        let parameters: [String:String] = [
            "UserID": "1",
            "Name": "Malcolm",
            "Email": "malcolm@network.com",
            "IsCool": "true"
        ]
        
        do {
            let endpoint = EndPoint<Data>(path: "https://www.google.com/",
                                          isFullPath: true,
                                          method: .get,
                                          bodyParamaters: parameters,
                                          bodyEncoding:.jsonSerializationData)
            try urlRequest = endpoint.urlRequest()
            
            
            guard let data = urlRequest.httpBody,
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments ) as? [String:String]
            else {
                XCTAssertTrue(false, "fatal error")
                return
            }
            
            
            XCTAssertEqual(parameters, json)
        }catch {
            XCTAssertTrue(false, error.localizedDescription)
        }
    }
    
    func testJsonBodyParametersWithStringEncoderShouldFaild() {
        guard let url = URL(string: "https://www.google.com/") else {
            XCTAssertTrue(false, "Could not instantiate url")
            return
        }
        var urlRequest = URLRequest(url: url)
        let parameters: [String:String] = [
            "UserID": "1",
            "Name": "Malcolm",
            "Email": "malcolm@network.com",
            "IsCool": "true"
        ]
        
        do {
            let endpoint = EndPoint<Data>(path: "https://www.google.com/",
                                          isFullPath: true,
                                          method: .get,
                                          bodyParamaters: parameters,
                                          bodyEncoding:.jsonSerializationData)
            try urlRequest = endpoint.urlRequest()
            
            
           guard let data = urlRequest.httpBody,
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments ) as? [String:String]
            else {
                XCTAssertTrue(false, "fatal error")
                return
            }
            
            XCTAssertEqual(parameters, json)

        }catch {
            XCTAssertTrue(false, error.localizedDescription)
        }
    }
    
    
    func testStringBodyParameters() {
        
    }
    
    
    
    static var allTests = [
        ("testURLEncoding", testURLEncoding),
    ]
}
