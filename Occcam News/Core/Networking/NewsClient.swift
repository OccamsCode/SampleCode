//
//  NewsClient.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation
import UIKit

class NewAPIClient: Client {

    @Inject(\.cacheProvider) var cache: Cache<URL, UIImage>
    @Inject(\.environmentProvider) var environment: EnvironmentType
    @Inject(\.sessionProvider) var urlSession: URLSessionType

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
                completion(.failure(.invalidResponseStatusCode))
            }

        }
        return task
    }
}