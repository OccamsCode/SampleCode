//
//  Model.swift
//  Occcam News
//
//  Created by Brian Munjoma on 18/02/2021.
//

import Foundation

struct Meta: Decodable {
    let found: Int
    let returned: Int
    let limit: Int
    let page: Int
}

struct Article: Decodable {
    let uuid: UUID?
    let title: String
    let url: URL
    let imageUrl: URL?
    let publishedAt: Date
    let source: String

    enum CodingKeys: String, CodingKey {
        case uuid
        case title
        case url
        case imageUrl = "image_url"
        case publishedAt = "published_at"
        case source
    }

}

struct TopStoriesResponse: Decodable {
    let meta: Meta
    let data: [Article]
}

struct Source: Decodable {
    let id: String?
    let name: String?
}

struct TopHeadlines: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct SearchResult: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
