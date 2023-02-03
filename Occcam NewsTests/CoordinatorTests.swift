//
//  Occcam_NewsTests.swift
//  Occcam NewsTests
//
//  Created by Brian Munjoma on 15/02/2021.
//

import XCTest
@testable import Occcam_News

// swiftlint:disable all
class CoordinatorTests: XCTestCase {
    
    var apiClient: MockClient<String>!
    
    override func setUpWithError() throws {
        
        apiClient = MockClient(environment: MockEnvironment(), urlSession: MockURLSession())
    }
    
    override func tearDownWithError() throws {
        apiClient = nil
    }
    
    //MARK:- Main Coordinator Tests
    func test_InitialMainCoordinator_HasNoChildren() {
        
        // Given
        let sut = MainCoordinator(UIWindow())
        
        // When
        let result = sut.childCoordinators.count
        
        // Then
        XCTAssertEqual(result, 0)
        
    }
    
    func test_MainCoordinatorOnStart_HasTwoChild() {
        
        // Given
        let sut = MainCoordinator(UIWindow())
        sut.start()
        
        // When
        let result = sut.childCoordinators.count
        
        // Then
        XCTAssertEqual(result, 1)
    }
    
    //MARK:- Home Coordinator Tests
    func test_InitialHomeFlowCoordinator_HasNoChildren() {
        
        // Given
        let sut = HomeFlowCoordinator(UINavigationController(), client: apiClient)
        
        // When
        let result = sut.childCoordinators.count
        
        // Then
        XCTAssertEqual(result, 0)
        
    }
    
    func test_HomeFlowCoordinatorOnStart_HasNoChildren() {
        
        // Given
        let sut = HomeFlowCoordinator(UINavigationController(), client: apiClient)
        sut.start()
        
        // When
        let result = sut.childCoordinators.count
        
        // Then
        XCTAssertEqual(result, 0)
        
    }
    
    //MARK:- Search Coordinator Tests
    func test_InitialSearchFlowCoordinator_HasNoChildren() {
        
        // Given
        let sut = SearchFlowCoordinator(UINavigationController(), client: apiClient)
        
        // When
        let result = sut.childCoordinators.count
        
        // Then
        XCTAssertEqual(result, 0)
        
    }
    
    func test_SearchFlowCoordinatorOnStart_HasNoChildren() {
        
        // Given
        let sut = SearchFlowCoordinator(UINavigationController(), client: apiClient)
        sut.start()
        
        // When
        let result = sut.childCoordinators.count
        
        // Then
        XCTAssertEqual(result, 0)
        
    }
}
