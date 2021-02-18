//
//  Parser.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation

enum ParserError: Error {
    case jsonDecodeError
    
    var localizedDescription: String {
        switch self {
            case .jsonDecodeError: return "JSON Decoding Error"
        }
    }
}

protocol Parser {
    func parse<T>(_ data: Data, into type: T.Type, completion: @escaping (Result<T, ParserError>) -> Void) where T: Decodable
}
