//
//  Enironment.swift
//  Occcam News
//
//  Created by Brian Munjoma on 30/01/2023.
//

import Foundation

protocol EnvironmentType {
    var scheme: HTTP.Scheme { get }
    var endpoint: String { get }
    var addtionalHeaders: [String: String] { get }
    var port: Int? { get }
}

struct Environment: EnvironmentType, CustomStringConvertible {

    let scheme: HTTP.Scheme
    let endpoint: String
    let addtionalHeaders: [String: String]
    let port: Int?

    static var testing: Environment {
        return Environment(scheme: .unsecure, endpoint: "localhost", addtionalHeaders: [:], port: 8080)
    }

    var description: String {
        var output = "\(scheme.rawValue)-\(endpoint)"
        if let port = port {
            output += ":\(port)"
        }
        return output
    }
}
