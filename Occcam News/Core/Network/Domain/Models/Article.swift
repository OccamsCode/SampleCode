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
    let url: URL?
    let image: URL?
    let publishedAt: Date?
    let source: Source
}
