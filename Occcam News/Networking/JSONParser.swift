//
//  JSONParser.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation

class JSONParser: Parser {

    let decoder: JSONDecoder
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy

    init(_ dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601withFractionalSeconds) {
        self.decoder = JSONDecoder()
        self.dateDecodingStrategy = dateDecodingStrategy
    }

    func parse<T>(_ data: Data,
                  into type: T.Type) throws -> T where T: Decodable {
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return try decoder.decode(T.self, from: data)
    }

    func parse<T>(_ data: Data,
                  into type: T.Type,
                  completion: @escaping (Result<T, ParserError>) -> Void) where T: Decodable {
        decoder.dateDecodingStrategy = dateDecodingStrategy
        do {
            let result = try decoder.decode(T.self, from: data)
            completion(.success(result))
        } catch {
            Log.error(error)
            completion(.failure(.jsonDecodeError))
        }
    }

}
