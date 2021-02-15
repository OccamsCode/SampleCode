//
//  APIClient.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation

enum APIError: Error, Equatable {

    case invalidData
    case invalidResponse
    case invalidResponseStatusCode
    case responseError
    
    var localizedDescription: String {
        switch self {
        case .invalidData: return "Invalid Data"                                // No data sent
        case .invalidResponse: return "Invalid Response"                        // URLResponse not HTTPURLResponse
        case .invalidResponseStatusCode: return "Invalid Response StatusCode"   // Status Code not 2xx
        case .responseError: return "Response Error"                            // Error from Request
        }
    }
}

protocol URLSessionTaskProtocol {
    func resume()
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol
}

protocol APIClient {
    var session: URLSessionProtocol { get }
    func fetch(with request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void)
}

extension APIClient {
    
    func fetch(with request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void) {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                debugPrint(error)
                return completion(.failure(.responseError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(.invalidResponse))
            }
            
            switch httpResponse.statusCode {
            
            case 200...299:
                
                guard let data = data else { return completion(.failure(.invalidData)) }
                completion(.success(data))
                
            default:
                completion(.failure(.invalidResponseStatusCode))
            }
            
        }
        
        task.resume()
        
    }
    
}
