import XCTest
@testable import Networking

final class NetworkingTests: XCTestCase {
    func testURLEncoding() {
        guard let url = URL(string: "https:www.google.com/") else {
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
        
//        do {
//            let encoder = URLParameterEncoder()
//            try encoder.encode(urlRequest: &urlRequest, with: parameters)
//            guard let fullURL = urlRequest.url else {
//                XCTAssertTrue(false, "urlRequest url is nil.")
//                return
//            }
//            
//            let expectedURL = "https:www.google.com/?Name=Malcolm&Email=malcolm%2540network.com&UserID=1&IsCool=true"
//            XCTAssertEqual(fullURL.absoluteString.sorted(), expectedURL.sorted())
//        }catch {
//            
//        }
        
        
    }
    
    static var allTests = [
        ("testURLEncoding", testURLEncoding),
    ]
}
