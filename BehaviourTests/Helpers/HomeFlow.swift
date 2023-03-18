//
//  HomeFlow.swift
//  BehaviourTests
//
//  Created by Brian Munjoma on 04/02/2023.
//

import Foundation

protocol HomeFlow {

    // MARK: - Home Screen
    func thenIShouldSeeHomeScreen()
}

import XCTest

extension HomeFlow where Self: UITest {

    // MARK: - Elements
    private var homeScreen: XCUIElement {
        app.otherElements["homeScreen"].firstMatch
    }

//    private var navigationBar: XCUIElement {
//        app.navigationBars.
//    }

    // MARK: - Actions

    // MARK: - Checks
    func thenIShouldSeeHomeScreen() {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(homeScreen.waitForExistence(timeout: 5))
        }
    }
}
