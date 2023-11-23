//
//  InjectedValues+Extension.swift
//  Occcam News
//
//  Created by Brian Munjoma on 17/11/2023.
//

import Foundation
import Injection
import Poppify

// MARK: - Providers
private struct SessionProviderKey: InjectionKey {
    static var currentValue: URLSessionType = URLSession.shared
}

private struct ClientProviderKey: InjectionKey {
    static var currentValue: Client = NewsClient()
}

private struct EnvironmentProviderKey: InjectionKey {
    static var currentValue: EnvironmentType = computedEnvironment

    static var computedEnvironment: EnvironmentType {
        guard let key = Bundle.main.infoDictionary?["SECRET_KEY"] as? String, key.count > 0 else {
            fatalError("App Key not supplied")
        }
        let item = URLQueryItem(name: "apikey", value: key)
        print("Using key ending with \(key.suffix(5))")
        return EnvironmentInfo(scheme: .secure,
                               endpoint: "gnews.io",
                               additionalHeaders: [:],
                               secret: .queryItem(item))
    }
}

// MARK: - Injected Values
extension InjectedValues {
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
