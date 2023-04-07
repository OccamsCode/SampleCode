//
//  Resource.swift
//  Occcam News
//
//  Created by Brian Munjoma on 30/01/2023.
//

import Foundation

struct Resource<T> {
    let request: Requestable
    let decode: (Data) throws -> T
}

extension Resource where T: Decodable {
    init(request: Requestable) {
        self.init(request: request) { data in
            do {
                let parser = JSONParser()
                return try parser.parse(data, into: T.self)
            } catch {
                throw error
            }
        }
    }
}
