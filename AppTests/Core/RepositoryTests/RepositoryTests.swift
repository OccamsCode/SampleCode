//
//  RepositoryTests.swift
//  AppTests
//
//  Created by Brian Munjoma on 18/11/2023.
//

import XCTest
@testable import Poppify
@testable import Occcam_News

final class RepositoryTests: XCTestCase {

    var sut: TopHeadlinesRepository!
    private var client: MockClient<RemoteHeadlines>!

    override func setUp() {
        client = MockClient<RemoteHeadlines>()
        let repo = NewsRepository()
        repo.client = client
        sut = repo
    }

    override func tearDown() {
        client = nil
        sut = nil
    }

    func test_ClientReturnsError_RepositoryReturnsError() async throws {

        client.returnValue = nil

        let result = try await sut.fetchTopHeadlines(inCategory: .general)

        XCTAssertEqual(result, .failure(.invalidData))
    }

    func test_ClientReturnsData_RepositoryReturnsData() async throws {

        client.returnValue = RemoteHeadlines(totalArticles: 1, articles: [
            RemoteArticle(title: "title",
                          description: "description",
                          content: "content",
                          url: URL(string: "www.google.com")!,
                          image: nil,
                          publishedAt: "todau",
                          source: .init(name: "name", url: "www.google.com"))
        ])

        guard case let .success(result) = try await sut.fetchTopHeadlines(inCategory: .general) else {
            return XCTFail("Success enum is not returned")
        }
        XCTAssertEqual(result.count, 1)
    }
}
