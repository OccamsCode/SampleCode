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
}
