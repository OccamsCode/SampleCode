//
//  DataStore.swift
//  Occcam News
//
//  Created by Brian Munjoma on 27/11/2023.
//

import Foundation

protocol Store: Actor {

    associatedtype Value

    func save(_ value: Value)
    func load() -> Value?
}

actor PlistStore<T: Codable>: Store where T: Equatable {

    var saved: T?
    let filename: String

    init(_ filename: String) {
        self.filename = filename
    }

    private var url: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(filename).plist")
    }

    func save(_ value: T) {
        if let saved = saved, saved == value { return }

        do {
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .binary
            let data = try encoder.encode(value)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Error saving to file \(url.lastPathComponent) - \(error.localizedDescription)")
        }
    }

    func load() -> T? {
        do {
           let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let value = try decoder.decode(T.self, from: data)
            saved = value
            return value
        } catch {
            print("Error reading file \(url.lastPathComponent) - \(error.localizedDescription)")
            return nil
        }
    }
}

actor PreviewStore: Store {
    typealias Value = [Article]

    func save(_ value: [Article]) {}
    func load() -> [Article]? { return nil }
}
