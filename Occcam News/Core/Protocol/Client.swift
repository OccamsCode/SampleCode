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
// swiftlint:disable line_length
enum APIError: Error, Equatable {

    case invalidData
    case invalidResponse
    case unhandledStatusCode(code: Int)
    case response(error: Error)
    case decode(error: Error)

    var localizedDescription: String {
        switch self {
        case .invalidData: return "Invalid Data"                                            // No data sent
        case .invalidResponse: return "Invalid Response"                                    // URLResponse not HTTPURLResponse
        case .unhandledStatusCode(let code): return "Invalid Response StatusCode \(code)"   // Status Code not 2xx
        case .response(let error): return "Response Error \(error)"                         // Error from Request
        case .decode(let error): return "Decode Error \(error)"                             // Error from Decoder
        }
    }

    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidData, .invalidData),
            (.invalidResponse, .invalidResponse),
            (.unhandledStatusCode(_), .unhandledStatusCode(_)),
            (.response(_), .response(_)),
            (.decode(_), .decode(_)):
            return true
        default: return false
        }
    }
}
// swiftlint:enable empty_enum_arguments
// swiftlint:enable line_length

protocol Client {

    var environment: EnvironmentType { get }
    var urlSession: URLSessionType { get }

    func dataTask<T>(with resource: Resource<T>,
                     completion: @escaping (Result<T, APIError>) -> Void ) -> URLSessionTaskType? where T: Decodable
}

extension Client {
    func dataTask<T>(with resource: Resource<T>,
                     completion: @escaping (Result<T, APIError>) -> Void ) -> URLSessionTaskType? {

        Log.verbose(resource.request)

        guard let urlReqest = URLRequest(request: resource.request,
                                         in: environment) else { return nil }

        let task = urlSession.dataTask(with: urlReqest) { data, response, error in

            if let error = error {
                return completion(.failure(.response(error: error)))
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(.invalidResponse))
            }

            switch httpResponse.statusCode {
            case 200...299:
                guard let data = data else { return completion(.failure(.invalidData)) }
                do {
                    let decoded = try resource.decode(data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(.decode(error: error)))
                }
            default:
                completion(.failure(.unhandledStatusCode(code: httpResponse.statusCode)))
            }

        }
        return task
    }
}
