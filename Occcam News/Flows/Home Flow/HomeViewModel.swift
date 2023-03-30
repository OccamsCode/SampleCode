//
//  HomeViewModel.swift
//  Occcam News
//
//  Created by Brian Munjoma on 04/03/2021.
//

import Foundation
import CoreGraphics.CGGeometry

struct TopHeadlinesRequest: Requestable {
    let path = "/api/v4/top-headlines"
    let parameters: [URLQueryItem]
}

class HomeViewModel {

    enum Constants {
        static let tabBarTitle = Localized.HomeViewModel.TabBarItem.text
        static let navigationTitle = Localized.HomeViewModel.NavigationItem.text
        static let refreshControlTitle = Localized.HomeViewModel.RefreshControl.text
    }

    private let client: Client
    private var articles: [Article]
    weak var coordinator: HomeFlowCoordinator?
    private(set) var generatedPreview: Previewable!

    init(client: Client, article: [Article] = []) {
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

    func article(at indexPath: IndexPath) -> Article? {
        if indexPath.row < 0 || indexPath.row >= numberOfItems(in: indexPath.section) { return nil }
        return articles[indexPath.row]
    }

    func cellViewModel(at indexPath: IndexPath) -> ArticleCellViewModel? {
        guard let article = article(at: indexPath) else { return nil }
        return ArticleCellViewModel(article)
    }

    func sizeForItem(at indexPath: IndexPath, given frame: CGSize) -> CGSize {
        guard cellViewModel(at: indexPath) != nil else { return .zero }
        let width = frame.width - 20    // TODO: This while knowing the content inset
        return CGSize(width: width, height: width * 0.8)
    }

    func update(completion: @escaping () -> Void) {

        // TODO: Setting page or language & country
        let topStories = TopHeadlinesRequest(parameters: [
            URLQueryItem(name: "lang", value: "en"),
            URLQueryItem(name: "country", value: "gb")
        ])
        let resource = Resource<TopHeadlinesResponse>(request: topStories)

        let task = client.dataTask(with: resource) { [unowned self] result in

            switch result {
            case .success(let topHeadlines):
                self.articles = topHeadlines.articles
                completion()
            case .failure(let failure):
                Log.error(failure)
            }
        }
        task?.resume()

    }

    func didSelectItem(at indexPath: IndexPath) {
        guard let selectedItem = article(at: indexPath) else { return }
        coordinator?.navigate(.toArticle(selectedItem))
    }

    func didSelectContextActionForItem(at indexPath: IndexPath) -> Previewable {
        guard let article = article(at: indexPath) else { fatalError() }
        generatedPreview = ViewControllerFactory.preview(for: article)
        return generatedPreview
    }

    func willPerformContextAction() {
        guard let preview = generatedPreview else { return }
        coordinator?.navigate(.toPreview(preview))
    }
}
