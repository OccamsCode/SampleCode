//
//  Mocks.swift
//  Occcam NewsTests
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation
@testable import Occcam_News

// swiftlint:disable all
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
        return ["q": "swift"]
    }

    var headers: HTTPHeaders {
        return ["Accept": "*/*"]
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
        return HTTPURLResponse(url: URL(string: "www.google.com")!,
                               statusCode: code,
                               httpVersion: nil,
                               headerFields: nil)!
    }

    static func create() -> URLResponse {
        return URLResponse(url: URL(string: "www.google.com")!,
                           mimeType: nil,
                           expectedContentLength: 1,
                           textEncodingName: nil)
    }

}

class MockURLSession: URLSessionProtocol {

    var data: Data?
    var response: URLResponse?
    var error: Error?

    func dataTask(with request: URLRequest,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol {
        return MockTask {
            completion(self.data, self.response, self.error)
        }
    }

}

// MARK: - Parser Tests
struct MockModel: Decodable {
    let name: String
    let age: Int
    let isDone: Bool
}

enum State {
    case error, data
}

class MockParser<T: Decodable>: Parser {

    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970
    var state: State = .error
    var item: T!

    func parse<T>(_ data: Data,
                  into type: T.Type,
                  completion: @escaping (Result<T, ParserError>) -> Void) where T: Decodable {
        switch state {
        case .error: completion(.failure(.jsonDecodeError))
        case .data: completion(.success(item as! T))
        }
    }

}

class MockClient: APIClient {

    var state: State
    var session: URLSessionProtocol
    var parser: Parser

    init(_ session: URLSessionProtocol, parser: Parser) {
        self.parser = parser
        self.session = session
        self.state = .error
    }

    func fetch(with request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void) {
        switch state {
        case .error: completion(.failure(.response(error: MockError.err)))
        case .data:
            let type = type(of: self)
            let bundle = Bundle(for: type.self)
            let path = bundle.url(forResource: "responseTopHeadlines", withExtension: "json")!
            let data = try! Data(contentsOf: path)
            completion(.success(data))
        }
    }

}

class MockGenerator {

    static func createArticles(_ count: Int) -> [Article] {
        return Array(0..<count).map {
            Article(uuid: UUID(),
                    title: String($0),
                    url: URL(string: "apple.com")!,
                    imageUrl: URL(string: "apple.com")!,
                    publishedAt: Date(),
                    source: "Source")
        }
    }

}
