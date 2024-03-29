//
//  NewsRepository.swift
//  Occcam News
//
//  Created by Brian Munjoma on 17/11/2023.
//

import Foundation
import Injection
import Poppify

protocol TopHeadlinesRepository {
    func fetchTopHeadlines(inCategory: NewsCategory) async throws -> Result<[Article], RequestError>
}

protocol SearchNewsRepository {
    func search(for query: String) async throws -> Result<[Article], RequestError>
}

final class NewsRepository {
    @Injected(\.clientProvider) var client
}

extension NewsRepository: TopHeadlinesRepository {
    func fetchTopHeadlines(inCategory category: NewsCategory) async throws -> Result<[Article], RequestError> {
        let request = TopHeadlinesRequest(category)
        let resource = Resource<RemoteHeadlines>(request: request)
        let result = await client.executeRequest(with: resource)

        switch result {
        case .success(let success):
            let (_, articles) = DomainMapper.map(success)
            return .success(articles)
        case .failure(let failure):
            return .failure(failure)
        }
    }
}

extension NewsRepository: SearchNewsRepository {
    func search(for query: String) async throws -> Result<[Article], RequestError> {
        let request = SearchRequest(query)
        let resource = Resource<RemoteHeadlines>(request: request)
        let result = await client.executeRequest(with: resource)

        switch result {
        case .success(let success):
            let (_, articles) = DomainMapper.map(success)
            return .success(articles)
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
