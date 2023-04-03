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
    static var currentValue: Client = NewAPIClient()
}

private struct SessionProviderKey: InjectionKey {
    static var currentValue: URLSessionType = URLSession.shared
}

private struct EnvironmentProviderKey: InjectionKey {
    static var currentValue: EnvironmentType = computedEnvironment

    static var computedEnvironment: EnvironmentType {
        if ProcessInfo.processInfo.arguments.contains("--test") {
            return Environment.testing
        } else {
            let key = Bundle.main.infoDictionary?["SECRET_KEY"] as? String
            let item = URLQueryItem(name: "apikey", value: key)
            return Environment(scheme: .secure,
                               endpoint: "gnews.io",
                               addtionalHeaders: [:],
                               port: nil,
                               secret: .queryItem(item))
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

    var sessionProvider: URLSessionType {
        get { Self[SessionProviderKey.self] }
        set { Self[SessionProviderKey.self] = newValue }
    }

    var environmentProvider: EnvironmentType {
        get { Self[EnvironmentProviderKey.self] }
        set { Self[EnvironmentProviderKey.self] = newValue }
    }
}
