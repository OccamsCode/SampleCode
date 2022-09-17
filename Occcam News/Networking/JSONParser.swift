//
//  JSONParser.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension JSONDecoder.DateDecodingStrategy {
    static let iso8601withFractionalSeconds = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        guard let date = Formatter.iso8601withFractionalSeconds.date(from: string) else {
            throw DecodingError.dataCorruptedError(in: container,
                  debugDescription: "Invalid date: " + string)
        }
        return date
    }
}

class JSONParser: Parser {
    
    let decoder: JSONDecoder
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy
    
    init(_ dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601withFractionalSeconds) {
        self.decoder = JSONDecoder()
        self.dateDecodingStrategy = dateDecodingStrategy
    }
    
    func parse<T>(_ data: Data, into type: T.Type, completion: @escaping (Result<T, ParserError>) -> Void) where T : Decodable {
        
        decoder.dateDecodingStrategy = dateDecodingStrategy
        do {
            let result = try decoder.decode(T.self, from: data)
            completion(.success(result))
        } catch {
            debugPrint(error)
            completion(.failure(.jsonDecodeError))
        }
        
    }
    
}
