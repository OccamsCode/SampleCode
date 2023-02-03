//
//  HTTP.swift
//  Occcam News
//
//  Created by Brian Munjoma on 30/01/2023.
//

import Foundation

// swiftlint:disable nesting
enum HTTP {

    enum Header {

        struct Key: ExpressibleByStringLiteral {
            let rawValue: String

            init(stringLiteral value: String) {
                self.rawValue = value
            }

            static let accept = "Accept"
        }

        struct Value: ExpressibleByStringLiteral {
            let rawValue: String

            init(stringLiteral value: String) {
                self.rawValue = value
            }

            static let json = "application/json"
        }
    }

    enum Scheme: String {
        case secure = "https"
        case unsecure = "http"
    }

    enum Method: String {
        case GET, POST, PUT, DELETE
    }
}
// swiftlint:enable nesting
