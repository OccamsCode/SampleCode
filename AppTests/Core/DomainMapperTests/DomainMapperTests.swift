//
//  DomainMapperTests.swift
//  AppTests
//
//  Created by Brian Munjoma on 15/11/2023.
//

import XCTest
@testable import Occcam_News

final class DomainMapperTests: XCTestCase {

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

    func testMap_RemoteArticle_to_Article() {
        let object = RemoteArticle(title: "title",
                                   description: "description",
                                   content: "content",
                                   url: "https://bc.ctvnews.ca/b-c-to-test-emergency-alert-system-wednesday-1.6644970",
                                   image: "https://bc.ctvnews.ca",
                                   publishedAt: "2023-11-15T11:35:55Z",
                                   source: RemoteSource(name: "BBC", url: "https://www.bbc.co.uk/news"))
        let result = DomainMapper.map(object)

        XCTAssertEqual(result.title, object.title)
        XCTAssertEqual(result.description, object.description)
        XCTAssertEqual(result.url?.absoluteString, object.url)
        XCTAssertEqual(result.image?.absoluteString, object.image)
        XCTAssertNotNil(result.publishedAt)
    }

    func testMap_RemoteArticleInvalidURL_to_Article() {
        let object = RemoteArticle(title: "title",
                                   description: "description",
                                   content: "content",
                                   url: "Invalid URL",
                                   image: "https://bc.ctvnews.ca",
                                   publishedAt: "2023-11-15T11:35:55Z",
                                   source: RemoteSource(name: "BBC", url: "https://www.bbc.co.uk/news"))
        let result = DomainMapper.map(object)

        XCTAssertEqual(result.title, object.title)
        XCTAssertEqual(result.description, object.description)
        XCTAssertNil(result.url)
        XCTAssertEqual(result.image?.absoluteString, object.image)
        XCTAssertNotNil(result.publishedAt)
    }

    func testMap_RemoteArticleInvalidImage_to_Article() {
        let object = RemoteArticle(title: "title",
                                   description: "description",
                                   content: "content",
                                   url: "https://bc.ctvnews.ca/b-c-to-test-emergency-alert-system-wednesday-1.6644970",
                                   image: "Invalid Image",
                                   publishedAt: "2023-11-15T11:35:55Z",
                                   source: RemoteSource(name: "BBC", url: "https://www.bbc.co.uk/news"))
        let result = DomainMapper.map(object)

        XCTAssertEqual(result.title, object.title)
        XCTAssertEqual(result.description, object.description)
        XCTAssertEqual(result.url?.absoluteString, object.url)
        XCTAssertNil(result.image)
        XCTAssertNotNil(result.publishedAt)
    }

    func testMap_RemoteArticleInvalidPublishedAtDate_to_Article() {
        let object = RemoteArticle(title: "title",
                                   description: "description",
                                   content: "content",
                                   url: "https://bc.ctvnews.ca/b-c-to-test-emergency-alert-system-wednesday-1.6644970",
                                   image: "https://bc.ctvnews.ca",
                                   publishedAt: "Invalid",
                                   source: RemoteSource(name: "BBC", url: "https://www.bbc.co.uk/news"))
        let result = DomainMapper.map(object)

        XCTAssertEqual(result.title, object.title)
        XCTAssertEqual(result.description, object.description)
        XCTAssertEqual(result.url?.absoluteString, object.url)
        XCTAssertEqual(result.image?.absoluteString, object.image)
        XCTAssertNil(result.publishedAt)
    }
}
