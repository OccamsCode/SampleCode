//
//  InjectionKey.swift
//  Occcam News
//
//  Created by Brian Munjoma on 02/04/2023.
//

import Foundation

public protocol InjectionKey {

    /// The associated type representing the type of the dependency injection key's value.
    associatedtype Value

    /// The default value for the dependency injection key.
    static var currentValue: Self.Value { get set }
}
