//
//  Endpoint.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

typealias HTTPHeaders = [String: String]
typealias Parameters = [String: String]

protocol Endpoint: CustomStringConvertible {
    var baseURL: String { get } // api.github.com
    var path: String { get } // /search/repositories
    var method: HTTPMethod { get } // .GET
    var parameters: Parameters? { get } // ["q" : "swift"]
    var headers: HTTPHeaders { get } // ["Authorization" : "Bearer SOME_TOKEN"]
}

extension Endpoint {

    var request: URLRequest {

        var urlComponents = URLComponents()

        if ProcessInfo.processInfo.arguments.contains("--uitest") {
            urlComponents.scheme = "http"
            urlComponents.host = "localhost"
            urlComponents.port = 8080
        } else {
            urlComponents.scheme = "https"
            urlComponents.host = baseURL
        }

        urlComponents.path = path

        if let params = parameters {
            urlComponents.queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
        }

        guard let url = urlComponents.url else { fatalError("Unable to create the URL") }

        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue
        headers.forEach { (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }

    var description: String {
        return """
        
        ⌜--------------------
        Request: \(method.rawValue) - \(baseURL)\(path)
        Headers: \(headers.sorted(by: <).reduce("", { $0 + "\($1.key): \($1.value)," }))
        Date: \(Date())
        Parameters: \(parameters?.sorted(by: <).reduce("", { $0 + "\($1.key): \($1.value)," }) ?? "nil")
        ⌞--------------------
        """
    }
}
