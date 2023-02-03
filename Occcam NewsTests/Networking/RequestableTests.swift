//
//  RequestableTests.swift
//  Occcam NewsTests
//
//  Created by Brian Munjoma on 31/01/2023.
//

import XCTest
@testable import Occcam_News

final class DefaultRequestableTests: XCTestCase {

    var sut: Requestable!
    let mockPath = "/v1/mock"

    override func setUpWithError() throws {
        sut = MockDefaultRequest(path: mockPath)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testDefaultValue_method_isGET() {

        let result = sut.method

        XCTAssertEqual(result, .GET)
    }

    func testDefaultValue_parameters_isEmpty() {

        let result = sut.parameters

        XCTAssertEqual(result, [])
    }

    func testDefaultValue_headers_isAcceptJSON() {

        let result = sut.headers

        XCTAssertEqual(result, [HTTP.Header.Key.accept: HTTP.Header.Value.json])
    }

    func testDefaultValue_body_isNil() {

        let result = sut.body

        XCTAssertNil(result)
    }
}

final class CustomRequestableTests: XCTestCase {

    var sut: Requestable!
    let mockPath = "/v1/mock"

    override func setUpWithError() throws {
        sut = MockCustomRequest(path: mockPath)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testCustomRequest_method_isPOST() {

        let result = sut.method

        XCTAssertEqual(result, .POST)
    }

    func testCustomRequest_parameters_isCorrectURLQueryItem() {

        let result = sut.parameters

        XCTAssertEqual(result, [URLQueryItem(name: "name", value: "value")])
    }

    func testCustomRequest_headers_isContentLength() {

        let result = sut.headers

        XCTAssertEqual(result, ["Content-Length": "348"])
    }

    func testCustomRequest_body_isNotNil() {

        let result = sut.body

        XCTAssertNotNil(result)
    }
}
