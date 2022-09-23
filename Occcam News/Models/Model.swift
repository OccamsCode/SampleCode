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

//TODO: Coding Keys
struct Article: Decodable {
    let uuid: UUID?
    let title: String
    let url: URL
    let image_url: URL?
    let published_at: Date
    let source: String
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
