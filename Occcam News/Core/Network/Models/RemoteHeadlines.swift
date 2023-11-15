//
//  RemoteHeadlines.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/11/2023.
//

import Foundation

// MARK: - Remote Headlines
struct RemoteHeadlines: Decodable {
    let totalArticles: Int
    let articles: [RemoteArticle]
}

// MARK: - Remote Article
struct RemoteArticle: Decodable {
    let title, description, content, url, image, publishedAt: String
    let source: RemoteSource
}

// MARK: - Remote Source
struct RemoteSource: Decodable {
    let name: String
    let url: String
}
