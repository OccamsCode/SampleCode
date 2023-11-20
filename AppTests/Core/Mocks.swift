//
//  Mocks.swift
//  AppTests
//
//  Created by Brian Munjoma on 20/11/2023.
//

import Foundation
@testable import Poppify
@testable import Occcam_News

class MockEnvironment: EnvironmentType {

    var scheme: HTTP.Scheme = .unsecure
    var endpoint: String = ""
    var additionalHeaders: [String: String] = [:]
    var port: Int?
    var secret: Secret?

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

    func sendRequest(for request: URLRequest) async throws -> (Data, URLResponse) {
        return (data!, response!)
    }

}

class MockClient<T: Decodable>: Client {

    var environment: EnvironmentType
    var urlSession: URLSessionType

    var returnValue: T?

    init(environment: EnvironmentType = MockEnvironment(), urlSession: URLSessionType = MockURLSession()) {
        self.environment = environment
        self.urlSession = urlSession
    }

    func executeRequest<T>(with resource: Resource<T>) async -> Result<T, RequestError> {
        guard let returnValue = returnValue as? T else {
            return .failure(.invalidData)
        }
        return .success(returnValue)
    }

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

enum MockError: Error {
    case err
}
