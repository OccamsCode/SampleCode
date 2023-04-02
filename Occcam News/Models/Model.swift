//
//  Model.swift
//  Occcam News
//
//  Created by Brian Munjoma on 18/02/2021.
//

import Foundation

struct Article: Decodable {

    struct Source: Decodable {
        let name: String?
        let url: String?
    }

    let title: String
    let url: URL
    let image: URL?
    let publishedAt: Date
    let source: Source

    enum CodingKeys: String, CodingKey {
        case title
        case url
        case image
        case publishedAt
        case source
    }

}

struct TopHeadlinesResponse: Decodable {
    let totalArticles: Int
    let articles: [Article]
}
