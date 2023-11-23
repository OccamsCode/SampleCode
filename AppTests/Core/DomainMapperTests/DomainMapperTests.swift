//
//  DomainMapperTests.swift
//  AppTests
//
//  Created by Brian Munjoma on 15/11/2023.
//

import XCTest
@testable import Occcam_News

// swiftlint:disable line_length
final class DomainMapperTests: XCTestCase {

    // MARK: - Remote Source
    func testMap_RemoteSource_to_Source() {
        let object = RemoteSource(name: "BBC", url: "https://www.bbc.co.uk/news")
        let result = DomainMapper.map(object)

        XCTAssertEqual(result.name, object.name)
        XCTAssertEqual(result.url?.absoluteString, object.url)
    }

    func testMap_RemoteSourceWithInvalidURL_to_Source() {
        let object = RemoteSource(name: "BBC", url: "Invalid URL")
        let result = DomainMapper.map(object)

        XCTAssertEqual(result.name, object.name)
        XCTAssertNil(result.url)
    }

    // MARK: - Remote Article
    func testMap_RemoteArticle_to_Article() {
        let object = RemoteArticle(title: "title",
                                   description: "description",
                                   content: "content",
                                   url: URL(string: "https://bc.ctvnews.ca/b-c-to-test-emergency-alert-system-wednesday-1.6644970")!,
                                   image: URL(string: "https://bc.ctvnews.ca"),
                                   publishedAt: "2023-11-15T11:35:55Z",
                                   source: RemoteSource(name: "BBC", url: "https://www.bbc.co.uk/news"))
        let result = DomainMapper.map(object)

        XCTAssertEqual(result.title, object.title)
        XCTAssertEqual(result.description, object.description)
        XCTAssertEqual(result.url, object.url)
        XCTAssertEqual(result.image, object.image)
        XCTAssertNotNil(result.publishedAt)
    }

    func testMap_RemoteArticleInvalidImage_to_Article() {
        let object = RemoteArticle(title: "title",
                                   description: "description",
                                   content: "content",
                                   url: URL(string: "https://bc.ctvnews.ca/b-c-to-test-emergency-alert-system-wednesday-1.6644970")!,
                                   image: nil,
                                   publishedAt: "2023-11-15T11:35:55Z",
                                   source: RemoteSource(name: "BBC", url: "https://www.bbc.co.uk/news"))
        let result = DomainMapper.map(object)

        XCTAssertEqual(result.title, object.title)
        XCTAssertEqual(result.description, object.description)
        XCTAssertEqual(result.url, object.url)
        XCTAssertNil(result.image)
        XCTAssertNotNil(result.publishedAt)
    }

    // MARK: - Remote Headlines
    func testMap_RemoteHeadlines_to_ArticlesCount() {
        let object = RemoteHeadlines(totalArticles: 1, articles: [
            RemoteArticle(title: "title",
                           description: "description",
                           content: "content",
                           url: URL(string: "https://bc.ctvnews.ca/b-c-to-test-emergency-alert-system-wednesday-1.6644970")!,
                           image: URL(string: "https://bc.ctvnews.ca"),
                           publishedAt: "2023-11-15T11:35:55Z",
                           source: RemoteSource(name: "BBC", url: "https://www.bbc.co.uk/news"))
        ])
        let (resultCount, resultArticles)  = DomainMapper.map(object)

        XCTAssertEqual(resultCount, object.totalArticles)
        XCTAssertEqual(resultArticles.count, object.articles.count)
    }

    func testMap_EmptyRemoteHeadlines_to_ArticlesCount() {
        let object = RemoteHeadlines(totalArticles: 0, articles: [])
        let (resultCount, resultArticles)  = DomainMapper.map(object)

        XCTAssertEqual(resultCount, object.totalArticles)
        XCTAssertEqual(resultArticles.count, object.articles.count)
    }
}
// swiftlint:enable line_length
