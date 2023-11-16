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

extension Article: Previewable {
    static var preview: Article {
        return Article(title: "NASA and ISRO to launch NISAR mission in 2024; know all about it",
                       description:  "Know all about NISAR mission tests and the expected launch date from NASA NISAR Project Manager Phil Barela. It is a joint NASA and ISRO project.",
                       url: URL(string: "https://bc.ctvnews.ca/b-c-to-test-emergency-alert-system-wednesday-1.6644970")!,
                       image: URL(string: "https://www.svtstatic.se/image-news/1200/1.91:1/0.5/0.5/c5d6c2228b01106b63e91e67f80d5ecab2abcf0f384051dd8cf59eb39910ab09"),
                       publishedAt: .distantPast,
                       source: .preview)
    }
}
