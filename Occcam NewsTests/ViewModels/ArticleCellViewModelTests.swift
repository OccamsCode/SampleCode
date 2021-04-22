//
//  ArticleCellViewModelTests.swift
//  Occcam NewsTests
//
//  Created by Brian Munjoma on 21/04/2021.
//

import XCTest
@testable import Occcam_News

class ArticleCellViewModelTests: XCTestCase {
    
    var sut: HomeArticleCellViewModel!
    var mockListCellDelegate: MockArticleCellDelegate!
    
    override func setUpWithError() throws {
        sut = HomeArticleCellViewModel([])
        mockListCellDelegate = MockArticleCellDelegate()
        sut.delegate = mockListCellDelegate
    }
    
    override func tearDownWithError() throws {
        mockListCellDelegate = nil
        sut = nil
    }
    
    //MARK:- Number of Sections
    func test_InitialViewModel_NumberOfSections_ZeroCount() {
        
        let result = sut.numberOfSections
        
        XCTAssertEqual(result, 0)
    }
    
    func test_SingleModel_NumberOfSections_OneCount() {
        
        let models = MockGenerator.createArticles(1)
        sut = HomeArticleCellViewModel(models)
        
        let result = sut.numberOfSections
        
        XCTAssertEqual(result, 1)
    }
    
    func test_MultipleModels_NumberOfSections_OneCount() {
        
        let models = MockGenerator.createArticles(3)
        sut = HomeArticleCellViewModel(models)
        
        let result = sut.numberOfSections
        
        XCTAssertEqual(result, 1)
    }
    
    //MARK:- Number of Items
    func test_InitialViewModel_NumberOfItemsInSectionZero_ZeroCount() {
        
        let section = 0
        let result = sut.numberOfItems(in: section)
        
        XCTAssertEqual(result, 0)
        
    }
    
    func test_InitialViewModel_NumberOfItemsInSectionNegative_ZeroCount() {
        
        let section = -1
        let result = sut.numberOfItems(in: section)
        
        XCTAssertEqual(result, 0)
        
    }
    
    func test_InitialViewModel_NumberOfItemsInSectionThree_ZeroCount() {
        
        let section = 3
        let result = sut.numberOfItems(in: section)
        
        XCTAssertEqual(result, 0)
        
    }
    
    func test_SingleModel_NumberOfItemsInSectionZero_OneCount() {
        
        let models = MockGenerator.createArticles(1)
        sut = HomeArticleCellViewModel(models)
        let section = 0
        
        let result = sut.numberOfItems(in: section)
        
        XCTAssertEqual(result, 1)
    }
    
    func test_SingleModel_NumberOfItemsInSectionNegative_ZeroCount() {
        
        let models = MockGenerator.createArticles(1)
        sut = HomeArticleCellViewModel(models)
        let section = -1
        
        let result = sut.numberOfItems(in: section)
        
        XCTAssertEqual(result, 0)
    }
    
    func test_SingleModel_NumberOfItemsInSectionThree_OneCount() {
        
        let models = MockGenerator.createArticles(1)
        sut = HomeArticleCellViewModel(models)
        let section = 3
        
        let result = sut.numberOfItems(in: section)
        
        XCTAssertEqual(result, 0)
    }
    
    func test_ThreeModel_NumberOfItemsInSectionZero_ThreeCount() {
        
        let models = MockGenerator.createArticles(3)
        sut = HomeArticleCellViewModel(models)
        let section = 0
        
        let result = sut.numberOfItems(in: section)
        
        XCTAssertEqual(result, 3)
    }
    
    func test_ThreeModel_NumberOfItemsInSectionNegative_ZeroCount() {
        
        let models = MockGenerator.createArticles(3)
        sut = HomeArticleCellViewModel(models)
        let section = -1
        
        let result = sut.numberOfItems(in: section)
        
        XCTAssertEqual(result, 0)
    }
    
    func test_ThreeModel_NumberOfItemsInSectionThree_OneCount() {
        
        let models = MockGenerator.createArticles(1)
        sut = HomeArticleCellViewModel(models)
        let section = 3
        
        let result = sut.numberOfItems(in: section)
        
        XCTAssertEqual(result, 0)
    }
    
    //MARK:- Item at IndexPath
    func test_InitialModel_ItemAtIndexPathZero_IsNil() {
        
        let zero = IndexPath(row: 0, section: 0)
        
        let result = sut.item(at: zero)
        
        XCTAssertNil(result)
    }
    
    func test_IntialModel_ItemAtSectionZeroRowOne_IsNil() {
        
        let indexPath = IndexPath(row: 1, section: 0)
        
        let result = sut.item(at: indexPath)
        
        XCTAssertNil(result)
    }
    
    func test_InitialModel_ItemAtSectionOneRowOne_IsNil() {
        
        let indexPath = IndexPath(row: 1, section: 1)
        
        let result = sut.item(at: indexPath)
        
        XCTAssertNil(result)
    }
    
    func test_InitialModel_ItemAtSectionNegativeRowZero_IsNil() {
        
        let indexPath = IndexPath(row: 0, section: -1)
        
        let result = sut.item(at: indexPath)
        
        XCTAssertNil(result)
    }
    
    func test_InitialModel_ItemAtSectionZeroRowNegative_IsNil() {
        
        let indexPath = IndexPath(row: -1, section: 0)
        
        let result = sut.item(at: indexPath)
        
        XCTAssertNil(result)
    }
    
    func test_SingleModel_ItemAtIndexPathZero_IsNotNil() {
        
        let models = MockGenerator.createArticles(1)
        sut = HomeArticleCellViewModel(models)
        let zero = IndexPath(row: 0, section: 0)
        
        let result = sut.item(at: zero)
        
        XCTAssertNotNil(result)
    }
    
    func test_SingleModel_ItemAtSectionZeroRowOne_IsNil() {
        
        let models = MockGenerator.createArticles(1)
        sut = HomeArticleCellViewModel(models)
        let indexPath = IndexPath(row: 1, section: 0)
        
        let result = sut.item(at: indexPath)
        
        XCTAssertNil(result)
    }
    
    func test_SingleModel_ItemAtSectionOneRowOne_IsNil() {
        
        let models = MockGenerator.createArticles(1)
        sut = HomeArticleCellViewModel(models)
        let indexPath = IndexPath(row: 1, section: 1)
        
        let result = sut.item(at: indexPath)
        
        XCTAssertNil(result)
    }
    
    func test_SingleModel_ItemAtSectionNegativeRowZero_IsNil() {
        
        let models = MockGenerator.createArticles(1)
        sut = HomeArticleCellViewModel(models)
        let indexPath = IndexPath(row: 0, section: -1)
        
        let result = sut.item(at: indexPath)
        
        XCTAssertNil(result)
    }
    
    func test_SingleModel_ItemAtSectionZeroRowNegative_IsNil() {
        
        let models = MockGenerator.createArticles(1)
        sut = HomeArticleCellViewModel(models)
        let indexPath = IndexPath(row: -1, section: 0)
        
        let result = sut.item(at: indexPath)
        
        XCTAssertNil(result)
    }
    
    //MARK:- Size of Item
    
    //MARK:- Did Select Context Action
    
    //MARK:- Will Perform Context Action
}
