//
//  Injection.swift
//  Occcam News
//
//  Created by Brian Munjoma on 30/03/2023.
//

import Foundation

@propertyWrapper
struct Inject<T> {
    private let keyPath: WritableKeyPath<InjectedValues, T>
    var wrappedValue: T {
        get { InjectedValues[keyPath] }
        set { InjectedValues[keyPath] = newValue }
    }

    init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
}
