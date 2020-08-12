import XCTest
@testable import Networking

// MARK: - Api Token implementation

struct ApiConfigData {
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

class JWTInterceptor:InterceptorProtocol {
    private var refreshNeeds = false
    func needRevalidate() -> Bool {
        return false
    }
    
    //no need to change in life time of app so i leave it empty
    func setNeedRevalidate() {
        
    }
    
    func isErrorMine<T>(configData: T, error: Error) -> Bool where T : ConfigDataProtocol {
        return false
    }
    
    func revalidate<T>(configData: inout T, completion: (InterceptorResult) -> ()) where T : ConfigDataProtocol {
        completion(.success)
    }
}



final class AuthTests: BaseTestCase {
    
    let router = Router<ApiConfigData>(interceptors: [JWTInterceptor()])

    
    func testAuthWithHeaderToken() {
        struct ApiResponse:Decodable {
            let authenticated:Bool
            let token: String
        }
        let endPoint = EndPoint<ApiResponse>(
            path: "/bearer",
            method: .get)
        
        let expect = expectation(description: "request should complete")
        
        var result:Result<ApiResponse,NetworkError>? = nil
        router.request(with: endPoint) { (responseResult) in
            result = responseResult
            expect.fulfill()
        }
        waitForExpectations(timeout: timeout)

        switch result! {
        case .success(let obj):
            XCTAssertTrue(obj.authenticated)
            XCTAssertEqual(obj.token, "dejavuu")
        case .failure(let error):
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    
    
    
    static var allTests = [
        ("testURLEncoding", testAuthWithHeaderToken),
    ]
}

