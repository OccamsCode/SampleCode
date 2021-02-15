//
//  Mocks.swift
//  Occcam NewsTests
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation
@testable import Occcam_News

// MARK: - Endpoint Tests
class MockEndpoint: Endpoint {
    
    var baseURL: String {
        return "api.github.com"
    }
    
    var path: String {
        return "/search"
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var parameters: Parameters? {
        return ["q":"swift"]
    }
    
    var headers: HTTPHeaders {
        return ["Accept":"*/*"]
    }
    
}

// MARK: - Client Tests
enum MockError: Error {
    case err
}

class MockTask: URLSessionTaskProtocol {
    
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    func resume() {
        closure()
    }
}

class MockResponse {
    static func create(withCode code: Int) -> HTTPURLResponse {
        return HTTPURLResponse(url: URL(string: "www.google.com")!, statusCode: code, httpVersion: nil, headerFields: nil)!
    }
    
    static func create() -> URLResponse {
        return URLResponse(url: URL(string: "www.google.com")!, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
    }
}

class MockURLSession: URLSessionProtocol {
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol {
    
        return MockTask {
            completionHandler(self.data, self.response, self.error)
        }
        
    }
    
}
