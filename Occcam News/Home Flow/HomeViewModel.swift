//
//  HomeViewModel.swift
//  Occcam News
//
//  Created by Brian Munjoma on 04/03/2021.
//

import Foundation
import CoreGraphics.CGGeometry

class HomeViewModel {

    private let client: APIClient
    private var articles: [Article]
    weak var coordinator: HomeFlowCoordinator?

    init(client: APIClient, article: [Article] = []) {
        self.client = client
        self.articles = article
    }

    var numberOfSections: Int {
        articles.isEmpty ? 0 : 1
    }

    func numberOfItems(in section: Int) -> Int {
        if section < 0 || section >= numberOfSections { return 0 }
        return articles.count
    }

    func cellViewModel(at indexPath: IndexPath) -> ArticleCellViewModel? {
        if indexPath.row < 0 || indexPath.row >= numberOfItems(in: indexPath.section) { return nil }
        let articleViewModel = ArticleCellViewModel(articles[indexPath.row])
        return articleViewModel
    }

    func sizeForItem(at indexPath: IndexPath, given frame: CGSize) -> CGSize {
        guard cellViewModel(at: indexPath) != nil else { return .zero }
        let width = frame.width - 20    // TODO: This while knowing the content inset
        return CGSize(width: width, height: width * 0.8)
    }

    func update(completion: @escaping () -> Void) {
        let topStories = TheNewsAPI.topStories

        client.fetch(from: topStories, into: TopStoriesResponse.self) { [unowned self] result in

            switch result {
            case .success(let topHeadlines):
                self.articles = topHeadlines.data
                completion()
            case .failure(let error):
                Log.error(error)
            }
        }
    }

    func didSelectItem(at indexPath: IndexPath) {
        if indexPath.row < 0 || indexPath.row >= numberOfItems(in: indexPath.section) { return }
        coordinator?.navigate(.toArticle(articles[indexPath.row]))
    }

}
