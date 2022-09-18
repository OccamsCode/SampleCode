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

extension URLSessionDataTask: URLSessionTaskProtocol {}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol {
        return self.dataTask(with: request, completionHandler: completion)
    }
}

protocol APIClient {
    var session: URLSessionProtocol { get }
    var parser: Parser { get }
    func fetch<T>(from endpoint: Endpoint, into type: T.Type, completion: @escaping (Result<T, APIError>) -> Void) where T: Decodable
    func fetch(from endpoint: Endpoint, completion: @escaping (Result<Data, APIError>) -> Void)
    func fetch(with request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void)
}

extension APIClient {
    
    func fetch<T>(from endpoint: Endpoint, into type: T.Type, completion: @escaping (Result<T, APIError>) -> Void) where T: Decodable {
        
        fetch(from: endpoint) { (fetchResult) in
            switch fetchResult {
            case .success(let data):
                parser.parse(data, into: T.self) { (parserResult) in
                    switch parserResult {
                    case .success(let decodedData): completion(.success(decodedData))
                    case .failure(let error):
                        Log.error(error)
                        completion(.failure(.invalidData))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func fetch(from endpoint: Endpoint, completion: @escaping (Result<Data, APIError>) -> Void) {
        
        let request = endpoint.request
        
        fetch(with: request, completion: completion)
        
    }
    
    func fetch(with request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void) {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                Log.error(error)
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
