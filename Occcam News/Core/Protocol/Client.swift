//
//  Client.swift
//  Occcam News
//
//  Created by Brian Munjoma on 30/01/2023.
//

import Foundation

protocol URLSessionTaskType {
    func resume()
}

extension URLSessionDataTask: URLSessionTaskType {}

protocol URLSessionType {
    func dataTask(with request: URLRequest,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskType
}

extension URLSession: URLSessionType {
    func dataTask(with request: URLRequest,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskType {
        return self.dataTask(with: request, completionHandler: completion)
    }
}

// swiftlint:disable empty_enum_arguments
enum APIError: Error, Equatable {

    case invalidData
    case invalidResponse
    case invalidResponseStatusCode
    case response(error: Error)
    case decode(error: Error)

    var localizedDescription: String {
        switch self {
        case .invalidData: return "Invalid Data"                                // No data sent
        case .invalidResponse: return "Invalid Response"                        // URLResponse not HTTPURLResponse
        case .invalidResponseStatusCode: return "Invalid Response StatusCode"   // Status Code not 2xx
        case .response(let error): return "Response Error \(error)"             // Error from Request
        case .decode(let error): return "Decode Error \(error)"                 // Error from Decoder
        }
    }

    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidData, .invalidData),
            (.invalidResponse, .invalidResponse),
            (.invalidResponseStatusCode, .invalidResponseStatusCode),
            (.response(_), .response(_)),
            (.decode(_), .decode(_)):
            return true
        default: return false
        }
    }
}
// swiftlint:enable empty_enum_arguments

protocol Client {

    var environment: EnvironmentType { get }
    var urlSession: URLSessionType { get }

    func dataTask<T>(with resource: Resource<T>,
                     completion: @escaping (Result<T, APIError>) -> Void ) -> URLSessionTaskType? where T: Decodable
}
