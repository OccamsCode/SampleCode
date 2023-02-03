//
//  ClientTest.swift
//  Occcam NewsTests
//
//  Created by Brian Munjoma on 15/02/2021.
//

import XCTest
@testable import Occcam_News

// swiftlint:disable all
/*class ClientTest: XCTestCase {
    
    var sut: NewAPIClient!
    var mockEnvironment: MockEnvironment!
    var mockSession: MockURLSession!
    var mockResource: Resource<String>!

    override func setUpWithError() throws {
        
        mockSession = MockURLSession()
        mockEnvironment = MockEnvironment()
        mockResource = Resource(request: MockDefaultRequest("/v1/mock")) { _ in return "Mock" }
        
        sut = NewAPIClient(environment: mockEnvironment, urlSession: mockSession)
    }

    override func tearDownWithError() throws {
       
        mockSession = nil
        mockEnvironment = nil
        sut = nil
    }

    func test_Client_NoData_NoResponse_WithError() {

        // Given
        mockSession.error = MockError.err
        var apiError: APIError?

        let request = URLRequest(url: URL(string: "www.google.com")!)
        let expecation = expectation(description: "Loading URL")
        
        // When
        sut.dataTask(with: mockResource) { result in
            switch result {
            case .failure(let error): apiError = error
            default: break
            }
            
            expecation.fulfill()
        }?.resume()
        
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
        sut.dataTask(with: mockResource) { result in
            switch result {
            case .failure(let error): apiError = error
            default: break
            }
            
            expecation.fulfill()
        }?.resume()
        
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
        sut.dataTask(with: mockResource) { result in
            switch result {
            case .failure(let error): apiError = error
            default: break
            }
            
            expecation.fulfill()
        }?.resume()
        
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
        sut.dataTask(with: mockResource) { result in
            switch result {
            case .failure(let error): apiError = error
            default: break
            }
            
            expecation.fulfill()
        }?.resume()
        
        wait(for: [expecation], timeout: 0.1)
        
        // Then
        XCTAssertEqual(apiError, APIError.invalidData)
    }
    
    func test_Client_WithData_Response200_NoError() {
        
        // Given
        mockSession.response = MockResponse.create(withCode: 200)
        mockSession.data = "data".data(using: .utf8)!
        var data: String?
        
        let request = URLRequest(url: URL(string: "www.google.com")!)
        let expecation = expectation(description: "Loading URL")
        
        // When
        sut.dataTask(with: mockResource) { result in
            switch result {
            case .success(let sData): data = sData
            default: break
            }
            
            expecation.fulfill()
        }?.resume()
        
        wait(for: [expecation], timeout: 0.1)
        
        // Then
        XCTAssertNotNil(data)
    }

} */

// Error
// Response Tyope
//
