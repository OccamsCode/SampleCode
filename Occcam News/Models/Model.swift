//
//  Model.swift
//  Occcam News
//
//  Created by Brian Munjoma on 18/02/2021.
//

import Foundation

/*
 source": {
    "id": null,
    "name": "KXAN.com"
 }
 */
struct Source: Decodable {
    let id: String?
    let name: String
}

struct Article: Decodable {
    let author: String?
    let title: String
    let description: String?
    let url: URL
    let urlToImage: URL?
    let source: Source
    //let publishedAt: Date
}

struct TopHeadlines: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
