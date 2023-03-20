//
//  Mocks.swift
//  Occcam NewsTests
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation
@testable import Occcam_News

// swiftlint:disable all
// MARK: - Requestable Tests
struct MockDefaultRequest: Requestable {
    let path: String
}

struct MockCustomRequest: Requestable {
    let path: String
    var method: HTTP.Method { .POST }
    var parameters: [URLQueryItem] { return [URLQueryItem(name: "name", value: "value")] }
    var headers: [String: String] { return ["Content-Length": "348"] }
    var body: Data? { return Data() }
}

// MARK: - Client Tests
enum MockError: Error {
    case err
}

class MockTask: URLSessionTaskType {

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

class MockURLSession: URLSessionType {

    var data: Data?
    var response: URLResponse?
    var error: Error?

    func dataTask(with request: URLRequest,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskType {
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

    func parse<T>(_ data: Data, into type: T.Type) throws -> T where T : Decodable {
        switch state {
        case .error:
            throw ParserError.jsonDecodeError
        case .data:
            return item as! T
        }
    }

    func parse<T>(_ data: Data,
                  into type: T.Type,
                  completion: @escaping (Result<T, ParserError>) -> Void) where T: Decodable {
        switch state {
        case .error: completion(.failure(.jsonDecodeError))
        case .data: completion(.success(item as! T))
        }
    }

}

class MockEnvironment: EnvironmentType {

    var scheme: HTTP.Scheme = .unsecure
    var endpoint: String = ""
    var addtionalHeaders: [String : String] = [:]
    var port: Int? = nil
    var secret: Secret? = nil
    
}

class MockClient<T: Decodable>: Client {

    var state: State
    var item: T!
    var environment: EnvironmentType
    var urlSession: URLSessionType

    init(environment: EnvironmentType, urlSession: URLSessionType) {
        self.environment = environment
        self.urlSession = urlSession
        state = .error
    }

    func dataTask<T>(with resource: Resource<T>,
                     completion: @escaping (Result<T, APIError>) -> Void) -> URLSessionTaskType? where T : Decodable {
        switch state {
        case .error:
            return MockTask{ completion(.failure(.response(error: MockError.err))) }
        case .data:
            let type = type(of: self)
            let bundle = Bundle(for: type.self)
            let path = bundle.url(forResource: "responseTopHeadlines", withExtension: "json")!
            let data = try! Data(contentsOf: path)
            let coded = try! resource.decode(data)
            return MockTask{ completion(.success(coded)) }
        }
    }
    
}

class MockGenerator {

    static func createArticles(_ count: Int) -> [Article] {
        return Array(0..<count).map {
            Article(title: String($0),
                    url: URL(string: "apple.com")!,
                    image: URL(string: "apple.com")!,
                    publishedAt: Date(),
                    source: Article.Source(name: "Apple \($0)", url: "apple.com"))
        }
    }

}
