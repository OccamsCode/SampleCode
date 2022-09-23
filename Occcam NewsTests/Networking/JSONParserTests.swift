//
//  JSONParserTests.swift
//  Occcam NewsTests
//
//  Created by Brian Munjoma on 15/02/2021.
//

import XCTest
@testable import Occcam_News

// swiftlint:disable all
class JSONParserTests: XCTestCase {
    
    var sut: JSONParser!
    
    override func setUpWithError() throws {
        sut = JSONParser()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_InvalidData_ResultsInError() {
        
        var result: ParserError?
        
        let expecation = expectation(description: "JSON Parsing")
        let errData = "invalid".data(using: .utf8)!
        
        sut.parse(errData, into: MockModel.self) { _result in
            switch _result {
            case .failure(let error): result = error
            default: XCTFail()
            }
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 0.1)
        
        XCTAssertEqual(result, ParserError.jsonDecodeError)
        
    }
    
    func test_ValidData_NoError() {
        
        var result: MockModel?
        
        let expecation = expectation(description: "JSON Parsing")
        let errData = """
            {
                "name":"Gordon",
                "age":10,
                "isDone": true
            }
            """.data(using: .utf8)!
        
        sut.parse(errData, into: MockModel.self) { _result in
            switch _result {
            case .success(let model): result = model
            default: XCTFail()
            }
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 0.1)
        
        XCTAssertNotNil(result)
        
    }
    
}
