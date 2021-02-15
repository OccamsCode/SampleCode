//
//  JSONParser.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/02/2021.
//

import Foundation

struct JSONParser: Parser {
    
    func parse<T>(_ data: Data, into type: T.Type, completion: @escaping (Result<T, ParserError>) -> Void) where T : Decodable {
        
        let decoder = JSONDecoder()
        
        do {
            let result = try decoder.decode(T.self, from: data)
            completion(.success(result))
        } catch {
            debugPrint(error)
            completion(.failure(.jsonDecodeError))
        }
        
    }
    
}
