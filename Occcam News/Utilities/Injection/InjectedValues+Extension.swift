//
//  InjectedValues+Extension.swift
//  Occcam News
//
//  Created by Brian Munjoma on 02/04/2023.
//

import Foundation
import UIKit

private struct CacheProviderKey: InjectionKey {
    static var currentValue: Cache<URL, UIImage> = Cache()
}

private struct ClientProviderKey: InjectionKey {
    static var currentValue: Client = logicValue

    static var logicValue: Client {
        if ProcessInfo.processInfo.arguments.contains("--test") {
            return NewAPIClient(environment: Environment.testing, urlSession: URLSession.shared)
        } else {
            let key = Bundle.main.infoDictionary?["SECRET_KEY"] as? String
            let item = URLQueryItem(name: "apikey", value: key)
            let env = Environment(scheme: .secure,
                                  endpoint: "gnews.io",
                                  addtionalHeaders: [:],
                                  port: nil,
                                  secret: .queryItem(item))
            return NewAPIClient(environment: env, urlSession: URLSession.shared)
        }
    }
}

extension InjectedValues {
    var cacheProvider: Cache<URL, UIImage> {
        get { Self[CacheProviderKey.self] }
        set { Self[CacheProviderKey.self] = newValue }
    }

    var clientProvider: Client {
        get { Self[ClientProviderKey.self] }
        set { Self[ClientProviderKey.self] = newValue }
    }
}
