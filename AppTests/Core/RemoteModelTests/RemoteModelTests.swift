//
//  RemoteModelTests.swift
//  AppTests
//
//  Created by Brian Munjoma on 15/11/2023.
//

import XCTest
@testable import Occcam_News

// swiftlint:disable line_length
final class RemoteModelTests: XCTestCase {

    func test_Decoding_RemoteSource() throws {
        try decodeModel { (model: RemoteSource) in
            XCTAssertEqual(model.name, "CNN")
            XCTAssertEqual(model.url, "https://www.cnn.com")
        }
    }

    func test_Decoding_RemoteArticle() throws {
        try decodeModel { (model: RemoteArticle) in
            XCTAssertEqual(model.title, "B.C. to test emergency alert system Wednesday")
            XCTAssertEqual(model.description, "B.C. will be testing the emergency alert system Wednesday, sending a text message to cellphones and interrupting TV and radio broadcasts.")
            XCTAssertEqual(model.content, "B.C. will be testing the emergency alert system Wednesday, sending a text message to cellphones and interrupting TV and radio broadcasts.\nThe test will take place at 1:55 p.m., according to officials.\n\"This test will assess the system’s readiness for... [1086 chars]")
            XCTAssertEqual(model.url, "https://bc.ctvnews.ca/b-c-to-test-emergency-alert-system-wednesday-1.6644970")
            XCTAssertEqual(model.image, "https://www.ctvnews.ca/content/dam/ctvnews/en/images/2022/5/4/b-c--emergency-alert-1-5888682-1651698160718.png")
            XCTAssertEqual(model.publishedAt, "2023-11-15T11:35:55Z")
        }
    }

    func test_Decoding_RemoteHeadlines() throws {
        try decodeModel { (model: RemoteHeadlines) in
            XCTAssertEqual(model.totalArticles, 1760144)
            XCTAssertEqual(model.articles.count, 10)
        }
    }
}
// swiftlint:enable line_length
