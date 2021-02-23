//
//  TopHeadlinesViewModelTests.swift
//  Occcam NewsTests
//
//  Created by Brian Munjoma on 16/02/2021.
//

import XCTest
@testable import Occcam_News

class TopHeadlinesViewModelTests: XCTestCase {
    
    var sut: TopHeadlinesViewModel!
    var mockClient: APIClient!

    override func setUpWithError() throws {
    
        mockClient = MockClient(MockURLSession(), parser: MockParser<TopHeadlines>())
        sut = TopHeadlinesViewModel(client: mockClient, model: [])
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: - Initial State
    func test_EmptyViewModel_ZeroSections() {
        
        let result = sut.numberOfSections
        
        XCTAssertEqual(result, 0)
        
    }
    
    func test_EmptyViewModel_ZeroItemsInSectionZero() {
        
        let result = sut.numberOfItems(in: 0)
        
        XCTAssertEqual(result, 0)
        
    }
    
    func test_EmptyViewModel_NoItems() {
        
        let zero = IndexPath(row: 0, section: 0)
        let result = sut.item(at: zero)
        
        XCTAssertNil(result)
        
    }
    
    func test_EmptyViewModel_ZeroItemsInNegativeSection() {
        
        let result = sut.numberOfItems(in: -1)
        
        XCTAssertEqual(result, 0)
    }
    
    func test_EmptyViewModel_NoItemAtNegativeSection() {
        
        let negative = IndexPath(row: 0, section: -1)
        let result = sut.item(at: negative)
        
        XCTAssertNil(result)
    }
    
    func test_EmptyViewModel_NoItemAtNegativeRow() {
        
        let negative = IndexPath(row: -1, section: 0)
        let result = sut.item(at: negative)
        
        XCTAssertNil(result)
    }
    
    // MARK: - Three Items
    func test_ThreeModel_HasOneSection() {
        
        let models = MockGenerator.createArticles(3)
        sut = TopHeadlinesViewModel(client: mockClient, model: models)
        
        let result = sut.numberOfSections
        
        XCTAssertEqual(result, 1)
        
    }
    
    func test_ThreeModel_ThreeItemsInSectionZero() {
        
        let models = MockGenerator.createArticles(3)
        sut = TopHeadlinesViewModel(client: mockClient, model: models)
        
        let result = sut.numberOfItems(in: 0)
        
        XCTAssertEqual(result, 3)
        
    }
    
    func test_ThreeModel_ZeroItemsInSectionOne() {
        
        let models = MockGenerator.createArticles(3)
        sut = TopHeadlinesViewModel(client: mockClient, model: models)
        
        let result = sut.numberOfItems(in: 1)
        
        XCTAssertEqual(result, 0)
        
    }
    
    func test_ThreeModel_HasItemAtIndexPathZero() {
        
        let models = MockGenerator.createArticles(3)
        sut = TopHeadlinesViewModel(client: mockClient, model: models)
        
        let zero = IndexPath(row: 0, section: 0)
        let result = sut.item(at: zero)
        
        XCTAssertNotNil(result)
        
    }
    
    func test_ThreeModel_HasCorrectItemAtIndexPathZero() {

        let models = MockGenerator.createArticles(3)
        sut = TopHeadlinesViewModel(client: mockClient, model: models)
        
        let zero = IndexPath(row: 0, section: 0)
        let result = sut.item(at: zero)
        
        XCTAssertEqual(result?.title, models.first?.title)
        
    }
    
    func test_ThreeModel_HasCorrectItemAtRowOneSectionZero() {

        let models = MockGenerator.createArticles(3)
        let expectedTitle = models[1].title
        sut = TopHeadlinesViewModel(client: mockClient, model: models)
        
        let zero = IndexPath(row: 1, section: 0)
        let result = sut.item(at: zero)
        
        XCTAssertEqual(result?.title, expectedTitle)
        
    }
    
    func test_ThreeModel_HasCorrectItemAtRowTwoSectionZero() {

        let models = MockGenerator.createArticles(3)
        let expectedTitle = models[2].title
        sut = TopHeadlinesViewModel(client: mockClient, model: models)
        
        let zero = IndexPath(row: 2, section: 0)
        let result = sut.item(at: zero)
        
        XCTAssertEqual(result?.title, expectedTitle)
        
    }

    func test_ThreeModel_HasNoItemAtRowThreeSectionZero() {

        let models = MockGenerator.createArticles(3)
        sut = TopHeadlinesViewModel(client: mockClient, model: models)
        
        let zero = IndexPath(row: 3, section: 0)
        let result = sut.item(at: zero)
        
        XCTAssertNil(result)
        
    }
    
    func test_ThreeModel_ZeroItemsInNegativeSection() {

        let models = MockGenerator.createArticles(3)
        sut = TopHeadlinesViewModel(client: mockClient, model: models)
        
        let result = sut.numberOfItems(in: -1)
        
        XCTAssertEqual(result, 0)
    }
    
    func test_ThreeModel_NoItemAtNegativeSection() {

        let models = MockGenerator.createArticles(3)
        sut = TopHeadlinesViewModel(client: mockClient, model: models)
        
        let negative = IndexPath(row: 0, section: -1)
        let result = sut.item(at: negative)
        
        XCTAssertNil(result)
    }
    
    func test_ThreeModel_NoItemAtNegativeRow() {

        let models = MockGenerator.createArticles(3)
        sut = TopHeadlinesViewModel(client: mockClient, model: models)
        
        let negative = IndexPath(row: -1, section: 0)
        let result = sut.item(at: negative)
        
        XCTAssertNil(result)
    }

}
