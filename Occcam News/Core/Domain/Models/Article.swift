//
//  Article.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/11/2023.
//

import Foundation

struct Article {
    let title: String
    let description: String
    let url: URL
    let image: URL?
    let publishedAt: Date
    let source: Source
}

extension Article: Identifiable {
    var id: String {
        return title
    }
}

extension Article: Equatable {}
extension Article: Codable {}

// swiftlint: disable line_length
extension Article: Previewable {
    static func preview() -> Article {
        return Article(title: UUID().uuidString,
                       description: "Know all about NISAR mission tests and the expected launch date from NASA NISAR Project Manager Phil Barela. It is a joint NASA and ISRO project.",
                       url: URL(string: "https://bc.ctvnews.ca/b-c-to-test-emergency-alert-system-wednesday-1.6644970")!,
                       image: nil,
                       publishedAt: .distantPast,
                       source: .preview())
    }
}
// swiftlint: enable line_length
