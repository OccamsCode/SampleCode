//
//  Requestable.swift
//  Occcam News
//
//  Created by Brian Munjoma on 30/01/2023.
//

import Foundation

protocol Requestable: CustomStringConvertible {
    var method: HTTP.Method { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var headers: [String: String] { get }
    var body: Data? { get }
}

extension Requestable {
    var method: HTTP.Method { .GET }
    var parameters: [URLQueryItem] { return [] }
    var headers: [String: String] { return [HTTP.Header.Key.accept: HTTP.Header.Value.json] }
    var body: Data? { return nil }

    func fullURL(scheme: HTTP.Scheme, endpoint: String, port: Int?) -> URL? {
        var urlComponents = URLComponents()

        urlComponents.scheme = scheme.rawValue
        urlComponents.host = endpoint
        urlComponents.port = port
        urlComponents.path = path
        urlComponents.queryItems = parameters

        return urlComponents.url
    }

    var description: String {
        return """

        ⌜--------------------
        Request: \(method) - \(path)
        Headers: \(headers.sorted(by: <).reduce("", { $0 + "\($1.key): \($1.value)," }))
        Date: \(Date())
        Parameters: \(parameters)
        ⌞--------------------
        """
    }

}

extension URLRequest {

    init?(request: Requestable, in environment: EnvironmentType) {

        guard let fullURL = request.fullURL(scheme: environment.scheme,
                                            endpoint: environment.endpoint,
                                            port: environment.port) else { return nil }
        self.init(url: fullURL)
        self.httpMethod = request.method.rawValue

        request.headers.forEach { (key, value) in
            self.setValue(value, forHTTPHeaderField: key)
        }

        environment.addtionalHeaders.forEach { (key, value) in
            self.setValue(value, forHTTPHeaderField: key)
        }
    }
}
