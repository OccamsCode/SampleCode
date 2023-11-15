//
//  DomainMapper.swift
//  Occcam News
//
//  Created by Brian Munjoma on 15/11/2023.
//

import Foundation

enum DomainMapper {
    static func map(_ remoteModel: RemoteSource) -> Source {
        return Source(name: remoteModel.name,
                      url: URL(string: remoteModel.url))
    }

    static func map(_ remoteModel: RemoteArticle) -> Article {
        var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return formatter
        }()

        return Article(title: remoteModel.title,
                       description: remoteModel.description,
                       url: URL(string: remoteModel.url),
                       image: URL(string: remoteModel.image),
                       publishedAt: dateFormatter.date(from: remoteModel.publishedAt),
                       source: DomainMapper.map(remoteModel.source))
    }
}
