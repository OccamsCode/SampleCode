//
//  HomeViewModelTests.swift
//  Occcam NewsTests
//
//  Created by Brian Munjoma on 01/04/2021.
//

import XCTest
@testable import Occcam_News

class HomeViewModelTests: XCTestCase {
    
    var sut: HomeViewModel!
    var mockClient: MockClient!
    var jsonParser: JSONParser!

    override func setUpWithError() throws {
    
        jsonParser = JSONParser()
        mockClient = MockClient(MockURLSession(), parser: jsonParser)
        sut = HomeViewModel(client: mockClient)
    }

    override func tearDownWithError() throws {
        
        jsonParser = nil
        mockClient = nil
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
        let result = sut.cellViewModel(at: zero)
        
        XCTAssertNil(result)
        
    }
    
    func test_EmptyViewModel_ZeroItemsInNegativeSection() {
        
        let result = sut.numberOfItems(in: -1)
        
        XCTAssertEqual(result, 0)
    }
    
    func test_EmptyViewModel_NoItemAtNegativeSection() {
        
        let negative = IndexPath(row: 0, section: -1)
        let result = sut.cellViewModel(at: negative)
        
        XCTAssertNil(result)
    }
    
    func test_EmptyViewModel_NoItemAtNegativeRow() {
        
        let negative = IndexPath(row: -1, section: 0)
        let result = sut.cellViewModel(at: negative)
        
        XCTAssertNil(result)
    }
    
    // MARK: - Three Items
    func test_ThreeModels_HasOneSection() {
        
        let models = MockGenerator.createArticles(3)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Top Headline":viewModel])
        
        let result = sut.numberOfSections
        
        XCTAssertEqual(result, 1)
        
    }
    
    func test_ThreeModels_OneItemInSectionZero() {
        
        let models = MockGenerator.createArticles(3)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Top Headline":viewModel])
        
        let result = sut.numberOfItems(in: 0)
        
        XCTAssertEqual(result, 1)
        
    }
    
    func test_ThreeModels_ZeroItemsInSectionOne() {
        
        let models = MockGenerator.createArticles(3)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Top Headline":viewModel])
        
        let result = sut.numberOfItems(in: 1)
        
        XCTAssertEqual(result, 0)
        
    }
    
    func test_ThreeModels_HasItemAtIndexPathZero() {
        
        let models = MockGenerator.createArticles(3)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Top Headline":viewModel])
        
        let zero = IndexPath(row: 0, section: 0)
        let result = sut.cellViewModel(at: zero)
        
        XCTAssertNotNil(result)
        
    }
    
    func test_ThreeModels_ZeroItemsInNegativeSection() {

        let models = MockGenerator.createArticles(3)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Test":viewModel])
        
        let result = sut.numberOfItems(in: -1)
        
        XCTAssertEqual(result, 0)
    }
    
    func test_ThreeModels_NoItemAtNegativeSection() {

        let models = MockGenerator.createArticles(3)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Test":viewModel])
        
        let negative = IndexPath(row: 0, section: -1)
        let result = sut.cellViewModel(at: negative)
        
        XCTAssertNil(result)
    }
    
    func test_ThreeModels_NoItemAtNegativeRow() {

        let models = MockGenerator.createArticles(3)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Test":viewModel])
        
        let negative = IndexPath(row: -1, section: 0)
        let result = sut.cellViewModel(at: negative)
        
        XCTAssertNil(result)
    }
    
    // MARK: - Update
    func test_Update_HasSection() {

        let updateVM = expectation(description: "Update ViewModel")
        mockClient.state = .data
        sut = HomeViewModel(client: mockClient)

        sut.update {
            updateVM.fulfill()
        }
        
        wait(for: [updateVM], timeout: 1.0)
        
        let result = sut.numberOfSections
        
        XCTAssertGreaterThan(result, 0)
    }
    
    func test_Update_HasRowsInFirstSection() {
        
        let updateVM = expectation(description: "Update ViewModel")
        mockClient.state = .data
        sut = HomeViewModel(client: mockClient)

        sut.update {
            updateVM.fulfill()
        }
        
        wait(for: [updateVM], timeout: 1.0)
        
        let result = sut.numberOfItems(in: 0)
        
        XCTAssertGreaterThan(result, 0)
        
    }
    
    func test_Update_HasItem() {
        
        let updateVM = expectation(description: "Update ViewModel")
        mockClient.state = .data
        sut = HomeViewModel(client: mockClient)

        sut.update {
            updateVM.fulfill()
        }
        
        wait(for: [updateVM], timeout: 1.0)
        
        let result = sut.cellViewModel(at: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(result)
        
    }

    // MARK: - Section Headers
    func test_EmptyModel_SectionZero_HasNoSectionHeader() {
        
        let section = 0
        
        let result = sut.titleForHeader(at: section)
        
        XCTAssertNil(result)
        
    }
    
    func test_EmptyModel_NegativeSection_HasNoSectionHeader() {
        
        let section = -1
        
        let result = sut.titleForHeader(at: section)
        
        XCTAssertNil(result)
        
    }
    
    func test_SingleModel_SectionZero_HasSectionHeader() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Top Headline":viewModel])
        let section = 0
        
        let result = sut.titleForHeader(at: section)
        
        XCTAssertNotNil(result)
        
    }
    
    func test_SingleModel_SectionOne_HasNoSectionHeader() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Top Headline":viewModel])
        let section = 1
        
        let result = sut.titleForHeader(at: section)
        
        XCTAssertNil(result)
        
    }
    
    func test_SingleModel_NegativeSection_HasNoSectionHeader() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Top Headline":viewModel])
        let section = -1
        
        let result = sut.titleForHeader(at: section)
        
        XCTAssertNil(result)
        
    }
    
    // MARK: - Section Type
    func test_InitialModel_SectionZero_SectionTypeIsNone() {
        
        let section = 0
        
        let result = sut.sectionType(for: section)
        
        XCTAssertEqual(result, .none)
    }
    
    func test_InitialModel_SectionOne_SectionTypeIsNone() {
        
        let section = 1
        
        let result = sut.sectionType(for: section)
        
        XCTAssertEqual(result, .none)
    }
    
    func test_InitialModel_NegativeSection_SectionTypeIsNone() {
        
        let section = -1
        
        let result = sut.sectionType(for: section)
        
        XCTAssertEqual(result, .none)
    }
    
    func test_OneModel_SectionZero_SectionTypeIsTop() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Top Headline":viewModel])
        let section = 0
        
        let result = sut.sectionType(for: section)
        
        XCTAssertEqual(result, .top)
    }
    
    func test_OneModel_SectionOne_SectionTypeIsNone() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Top Headline":viewModel])
        let section = 1
        
        let result = sut.sectionType(for: section)
        
        XCTAssertEqual(result, .none)
    }
    
    func test_OneModel_NegativeSection_SectionTypeIsNone() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Top Headline":viewModel])
        let section = -1
        
        let result = sut.sectionType(for: section)
        
        XCTAssertEqual(result, .none)
    }
    
    func test_ThreeModels_SectionZero_SectionTypeIsTop() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        let data = [
            "Top Headline": viewModel,
            "general": viewModel,
            "technology": viewModel
        ]
        sut = HomeViewModel(client: mockClient, article: data)
        let section = 0
        
        let result = sut.sectionType(for: section)
        
        XCTAssertEqual(result, .top)
    }
    
    func test_ThreeModels_SectionOne_SectionTypeIsList() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        let data = [
            "Top Headline": viewModel,
            "general": viewModel,
            "technology": viewModel
        ]
        sut = HomeViewModel(client: mockClient, article: data)
        let section = 1
        
        let result = sut.sectionType(for: section)
        
        XCTAssertEqual(result, .list)
    }
    
    func test_ThreeModels_SectionTwo_SectionTypeIsList() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        let data = [
            "Top Headline": viewModel,
            "general": viewModel,
            "technology": viewModel
        ]
        sut = HomeViewModel(client: mockClient, article: data)
        let section = 2
        
        let result = sut.sectionType(for: section)
        
        XCTAssertEqual(result, .list)
    }
    
    func test_ThreeModels_SectionThree_SectionTypeIsNone() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        let data = [
            "Top Headline": viewModel,
            "general": viewModel,
            "technology": viewModel
        ]
        sut = HomeViewModel(client: mockClient, article: data)
        let section = 3
        
        let result = sut.sectionType(for: section)
        
        XCTAssertEqual(result, .none)
    }
    
    func test_ThreeModels_NegativeSection_SectionTypeIsNone() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        let data = [
            "Top Headline": viewModel,
            "general": viewModel,
            "technology": viewModel
        ]
        sut = HomeViewModel(client: mockClient, article: data)
        let section = -1
        
        let result = sut.sectionType(for: section)
        
        XCTAssertEqual(result, .none)
    }
    
    //MARK: Size For Item
    func test_InitialModel_IndexPathZero_SizeZero() {
        
        let indexPath = IndexPath(item: 0, section: 0)
        let size = CGSize(width: 320, height: 100)
        let result = sut.sizeForItem(at: indexPath, given: size)
        
        XCTAssertEqual(result, .zero)
    }
    
    func test_InitialModel_SectionOneItemZero_SizeZero() {
        
        let indexPath = IndexPath(item: 0, section: 1)
        let size = CGSize(width: 320, height: 100)
        let result = sut.sizeForItem(at: indexPath, given: size)
        
        XCTAssertEqual(result, .zero)
    }
    
    func test_InitialModel_SectionZeroItemOne_SizeZero() {
        
        let indexPath = IndexPath(item: 1, section: 0)
        let size = CGSize(width: 320, height: 100)
        let result = sut.sizeForItem(at: indexPath, given: size)
        
        XCTAssertEqual(result, .zero)
    }
    
    func test_InitialModel_NegativeIndexPath_SizeZero() {
        
        let indexPath = IndexPath(item: 0, section: -1)
        let size = CGSize(width: 320, height: 100)
        let result = sut.sizeForItem(at: indexPath, given: size)
        
        XCTAssertEqual(result, .zero)
    }
    
    func test_SingleModel_IndexPathZero_SizeNotZero() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Top Headline":viewModel])
        let size = CGSize(width: 320, height: 100)
        let indexPath = IndexPath(item: 0, section: 0)
        
        let result = sut.sizeForItem(at: indexPath, given: size)
        
        XCTAssertNotEqual(result, .zero)
    }
    
    func test_SingleModel_SectionOneItemZero_SizeZero() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Top Headline":viewModel])
        let size = CGSize(width: 320, height: 100)
        let indexPath = IndexPath(item: 0, section: 1)
        
        let result = sut.sizeForItem(at: indexPath, given: size)
        
        XCTAssertEqual(result, .zero)
    }
    
    func test_SingleModel_NegativeIndexPath_SizeZero() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Top Headline":viewModel])
        let size = CGSize(width: 320, height: 100)
        let indexPath = IndexPath(item: 0, section: -1)
        
        let result = sut.sizeForItem(at: indexPath, given: size)
        
        XCTAssertEqual(result, .zero)
    }
    
    func test_ThreeModel_IndexPathZero_SizeNotZero() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        let data = [
            "Top Headline": viewModel,
            "general": viewModel,
            "technology": viewModel
        ]
        sut = HomeViewModel(client: mockClient, article: data)
        
        let size = CGSize(width: 320, height: 100)
        let indexPath = IndexPath(item: 0, section: 0)
        
        let result = sut.sizeForItem(at: indexPath, given: size)
        
        XCTAssertNotEqual(result, .zero)
        
    }
    
    func test_ThreeModel_SectionOneItemZero_SizeNotZero() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        let data = [
            "Top Headline": viewModel,
            "general": viewModel,
            "technology": viewModel
        ]
        sut = HomeViewModel(client: mockClient, article: data)
        
        let size = CGSize(width: 320, height: 100)
        let indexPath = IndexPath(item: 0, section: 1)
        
        let result = sut.sizeForItem(at: indexPath, given: size)
        
        XCTAssertNotEqual(result, .zero)
        
    }
    
    func test_ThreeModel_SectionTwoItemZero_SizeNotZero() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        let data = [
            "Top Headline": viewModel,
            "general": viewModel,
            "technology": viewModel
        ]
        sut = HomeViewModel(client: mockClient, article: data)
        
        let size = CGSize(width: 320, height: 100)
        let indexPath = IndexPath(item: 0, section: 2)
        
        let result = sut.sizeForItem(at: indexPath, given: size)
        
        XCTAssertNotEqual(result, .zero)
        
    }
    
    func test_ThreeModel_SectionThreeItemZero_SizeZero() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        let data = [
            "Top Headline": viewModel,
            "general": viewModel,
            "technology": viewModel
        ]
        sut = HomeViewModel(client: mockClient, article: data)
        
        let size = CGSize(width: 320, height: 100)
        let indexPath = IndexPath(item: 0, section: 3)
        
        let result = sut.sizeForItem(at: indexPath, given: size)
        
        XCTAssertEqual(result, .zero)
        
    }
    
    func test_ThreeModel_NegativeSection_SizeZero() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        let data = [
            "Top Headline": viewModel,
            "general": viewModel,
            "technology": viewModel
        ]
        sut = HomeViewModel(client: mockClient, article: data)
        
        let size = CGSize(width: 320, height: 100)
        let indexPath = IndexPath(item: 0, section: -1)
        
        let result = sut.sizeForItem(at: indexPath, given: size)
        
        XCTAssertEqual(result, .zero)
        
    }
    
    // MARK:- Size For Header
    func test_InitialModel_SectionZero_SizeZero() {
        
        let section = 0
        let size = CGSize(width: 320, height: 100)
        let result = sut.sizeForHeader(at: section, given: size)
        
        XCTAssertEqual(result, .zero)
    }
    
    func test_InitialModel_SectionOne_SizeZero() {
        
        let section = 1
        let size = CGSize(width: 320, height: 100)
        let result = sut.sizeForHeader(at: section, given: size)
        
        XCTAssertEqual(result, .zero)
    }
    
    func test_InitialModel_NegativeSection_SizeZero() {
        
        let section = -1
        let size = CGSize(width: 320, height: 100)
        let result = sut.sizeForHeader(at: section, given: size)
        
        XCTAssertEqual(result, .zero)
    }
    
    func test_SingleModel_SectionZero_SizeZero() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Top Headline":viewModel])
        let size = CGSize(width: 320, height: 100)
        let section = 0
        
        let result = sut.sizeForHeader(at: section, given: size)
        
        XCTAssertEqual(result, .zero)
    }
    
    func test_SingleModel_SectionOne_SizeZero() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Top Headline":viewModel])
        let size = CGSize(width: 320, height: 100)
        let section = 1
        
        let result = sut.sizeForHeader(at: section, given: size)
        
        XCTAssertEqual(result, .zero)
    }
    
    func test_SingleModel_NegativeSection_SizeZero() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        sut = HomeViewModel(client: mockClient, article: ["Top Headline":viewModel])
        let size = CGSize(width: 320, height: 100)
        let section = -1
        
        let result = sut.sizeForHeader(at: section, given: size)
        
        XCTAssertEqual(result, .zero)
    }
    
    func test_ThreeModels_SectionZero_SizeZero() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        let data = [
            "Top Headline": viewModel,
            "general": viewModel,
            "technology": viewModel
        ]
        sut = HomeViewModel(client: mockClient, article: data)
        let size = CGSize(width: 320, height: 100)
        let section = 0
        
        let result = sut.sizeForHeader(at: section, given: size)
        
        XCTAssertEqual(result, .zero)
    }
    
    func test_ThreeModels_SectionOne_SizeNotZero() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        let data = [
            "Top Headline": viewModel,
            "general": viewModel,
            "technology": viewModel
        ]
        sut = HomeViewModel(client: mockClient, article: data)
        let size = CGSize(width: 320, height: 100)
        let section = 1
        
        let result = sut.sizeForHeader(at: section, given: size)
        
        XCTAssertNotEqual(result, .zero)
    }
    
    func test_ThreeModels_SectionTwo_SizeNotZero() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        let data = [
            "Top Headline": viewModel,
            "general": viewModel,
            "technology": viewModel
        ]
        sut = HomeViewModel(client: mockClient, article: data)
        let size = CGSize(width: 320, height: 100)
        let section = 2
        
        let result = sut.sizeForHeader(at: section, given: size)
        
        XCTAssertNotEqual(result, .zero)
    }
    
    func test_ThreeModels_SectionThree_SizeZero() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        let data = [
            "Top Headline": viewModel,
            "general": viewModel,
            "technology": viewModel
        ]
        sut = HomeViewModel(client: mockClient, article: data)
        let size = CGSize(width: 320, height: 100)
        let section = 3
        
        let result = sut.sizeForHeader(at: section, given: size)
        
        XCTAssertEqual(result, .zero)
    }
    
    func test_ThreeModels_NegativeSection_SizeZero() {
        
        let models = MockGenerator.createArticles(1)
        let viewModel = HomeArticleCellViewModel(models)
        let data = [
            "Top Headline": viewModel,
            "general": viewModel,
            "technology": viewModel
        ]
        sut = HomeViewModel(client: mockClient, article: data)
        let size = CGSize(width: 320, height: 100)
        let section = -1
        
        let result = sut.sizeForHeader(at: section, given: size)
        
        XCTAssertEqual(result, .zero)
    }
    // MARK:- Did Select Article
    func test_InitialViewModel_SelectedContextActionIndexPath_IsNil() {
        
        let result = sut.selectedContextActionIndexPath
        
        XCTAssertNil(result)
    }
    
    func test_DidSelectContextAction_SelectedContextActionIndexPath_IsNotNil() {
        
        let zero = IndexPath(row: 0, section: 0)
        sut.didSelectContextActionForItem(at: zero)
        
        let result = sut.selectedContextActionIndexPath
        
        XCTAssertNotNil(result)
    }
    
    func test_DidSelectContextAction_SelectedContextActionIndexPath_IsCorrect() {
        
        let zero = IndexPath(row: 0, section: 0)
        sut.didSelectContextActionForItem(at: zero)
        
        let result = sut.selectedContextActionIndexPath
        
        XCTAssertEqual(zero, result)
    }
    
    // MARK:- Did Select Item At IndexPath
    
    // MARK:- Did Select Context Action
    
    // MARK:- Will Select Context Action
}
