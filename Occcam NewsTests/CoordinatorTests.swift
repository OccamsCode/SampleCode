//
//  Occcam_NewsTests.swift
//  Occcam NewsTests
//
//  Created by Brian Munjoma on 15/02/2021.
//

import XCTest
@testable import Occcam_News

class CoordinatorTests: XCTestCase {
    
    func test_InitialMainCoordinator_HasNoChildren() {
        
        // Given
        let sut = MainCoordinator(UIWindow())
        
        // When
        let result = sut.childCoordinators.count
        
        // Then
        XCTAssertEqual(result, 0)
        
    }
    
    func test_MainCoordinatorOnStart_HasOneChild() {
        
        // Given
        let sut = MainCoordinator(UIWindow())
        sut.start()
        
        // When
        let result = sut.childCoordinators.count
        
        // Then
        XCTAssertEqual(result, 1)
    }

    func test_NewNewsFlowCoordinator_HasNoChildren() {
        
        // Given
        let sut = NewsFlowCoordinator(UINavigationController())
        
        // When
        let result = sut.childCoordinators.count
        
        // Then
        XCTAssertEqual(result, 0)
        
    }

    func test_NewsFlowCoordinator_HasNoChildren() {
        
        // Given
        let sut = NewsFlowCoordinator(UINavigationController())
        sut.start()
        
        // When
        let result = sut.childCoordinators.count
        
        // Then
        XCTAssertEqual(result, 0)
        
    }
}
