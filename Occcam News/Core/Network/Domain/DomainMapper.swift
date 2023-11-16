//
//  DomainMapper.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/11/2023.
//

import Foundation

enum DomainMapper {
    static func map(_ remoteSource: RemoteSource) -> Source {
        return Source(name: remoteSource.name,
                      url: URL(string: remoteSource.url))
    }

    static func map(_ remoteArticle: RemoteArticle) -> Article {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return formatter
        }()

        return Article(title: remoteArticle.title,
                       description: remoteArticle.description,
                       url: URL(string: remoteArticle.url),
                       image: URL(string: remoteArticle.image),
                       publishedAt: dateFormatter.date(from: remoteArticle.publishedAt) ?? .now,
                       source: map(remoteArticle.source))
    }

    static func map(_ remoteHeadlines: RemoteHeadlines) -> (Int, [Article]) {
        return (remoteHeadlines.totalArticles, remoteHeadlines.articles.map {map($0)})
    }
}
