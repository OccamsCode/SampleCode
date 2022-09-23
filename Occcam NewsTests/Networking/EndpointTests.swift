//
//  EndpointTests.swift
//  Occcam NewsTests
//
//  Created by Brian Munjoma on 15/02/2021.
//

import XCTest
@testable import Occcam_News

// swiftlint:disable all
class EndpointTests: XCTestCase {

    var sut: MockEndpoint!
    
    override func setUpWithError() throws {
        sut = MockEndpoint()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_Endpoint_Scheme () {
        
        let result = URLComponents(url: sut.request.url!, resolvingAgainstBaseURL: false)
        
        XCTAssertEqual(result?.scheme, "https")
        
    }
    
    func test_Endpoint_Host () {
        
        let result = URLComponents(url: sut.request.url!, resolvingAgainstBaseURL: false)
        
        XCTAssertEqual(result?.host, sut.baseURL)
        
    }
    
    func test_Endpoint_Path () {
        
        let result = URLComponents(url: sut.request.url!, resolvingAgainstBaseURL: false)
        
        XCTAssertEqual(result?.path, sut.path)
        
    }
    
    func test_Endpoint_QueryItems() {
        
        let result = URLComponents(url: sut.request.url!, resolvingAgainstBaseURL: false)
        
        XCTAssertEqual(result?.query, "q=swift")
        
    }
    
    func test_Endpoint_HTTPMethod () {
        
        let result = sut.request.httpMethod
        
        XCTAssertEqual(result, "GET")
        
    }
    
    func test_Endpoint_HTTPHeaders () {
        
        let result = sut.request.allHTTPHeaderFields!
        
        XCTAssertEqual(result,sut.headers)
        
    }

}
