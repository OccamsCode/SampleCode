//
//  APIClientTest.swift
//  Occcam NewsTests
//
//  Created by Brian Munjoma on 15/02/2021.
//

import XCTest
@testable import Occcam_News

// swiftlint:disable all
class APIClientTest: XCTestCase {
    
    var sut: NewsClient!
    var mockSession: MockURLSession!
    var mockParser: Parser!

    override func setUpWithError() throws {
        
        mockSession = MockURLSession()
        mockParser = MockParser<Bool>()
        
        sut = NewsClient(mockSession, jsonParser: mockParser)
    }

    override func tearDownWithError() throws {
       
        mockSession = nil
        mockParser = nil
        sut = nil
    }

    func test_Client_NoData_NoResponse_WithError() {

        // Given
        mockSession.error = MockError.err
        var apiError: APIError?

        let request = URLRequest(url: URL(string: "www.google.com")!)
        let expecation = expectation(description: "Loading URL")
        
        // When
        sut.fetch(with: request) { result in
            
            switch result {
            case .failure(let error): apiError = error
            default: break
            }
            
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 0.1)
        
        // Then
        XCTAssertEqual(apiError, APIError.response(error: MockError.err))
    }
    
    func test_Client_NoData_WrongResponseType_NoError() {
        
        // Given
        mockSession.response = MockResponse.create()
        var apiError: APIError?
        
        let request = URLRequest(url: URL(string: "www.google.com")!)
        let expecation = expectation(description: "Loading URL")
        
        // When
        sut.fetch(with: request) { result in
            
            switch result {
            case .failure(let error): apiError = error
            default: break
            }
            
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 0.1)
        
        // Then
        XCTAssertEqual(apiError, APIError.invalidResponse)
    }
    
    func test_Client_NoData_ResponseNot200_NoError() {
        
        // Given
        mockSession.response = MockResponse.create(withCode: 100)
        var apiError: APIError?
        
        let request = URLRequest(url: URL(string: "www.google.com")!)
        let expecation = expectation(description: "Loading URL")
        
        // When
        sut.fetch(with: request) { result in
            
            switch result {
            case .failure(let error): apiError = error
            default: break
            }
            
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 0.1)
        
        // Then
        XCTAssertEqual(apiError, APIError.invalidResponseStatusCode)
    }
    
    func test_Client_NoData_Response200_NoError() {
        
        // Given
        mockSession.response = MockResponse.create(withCode: 200)
        var apiError: APIError?
        
        let request = URLRequest(url: URL(string: "www.google.com")!)
        let expecation = expectation(description: "Loading URL")
        
        // When
        sut.fetch(with: request) { result in
            
            switch result {
            case .failure(let error): apiError = error
            default: break
            }
            
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 0.1)
        
        // Then
        XCTAssertEqual(apiError, APIError.invalidData)
    }
    
    func test_Client_WithData_Response200_NoError() {
        
        // Given
        mockSession.response = MockResponse.create(withCode: 200)
        mockSession.data = "data".data(using: .utf8)!
        var data: Data?
        
        let request = URLRequest(url: URL(string: "www.google.com")!)
        let expecation = expectation(description: "Loading URL")
        
        // When
        sut.fetch(with: request) { result in
            
            switch result {
            case .success(let sData): data = sData
            default: break
            }
            
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 0.1)
        
        // Then
        XCTAssertNotNil(data)
    }

}

// Error
// Response Tyope
//
