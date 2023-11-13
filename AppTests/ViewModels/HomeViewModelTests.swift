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

    override func setUpWithError() throws {

        sut = HomeViewModel()
        sut.client = MockClient<String>(environment: MockEnvironment(),
                                        urlSession: MockURLSession())
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
        sut = HomeViewModel(article: models)
        let result = sut.numberOfSections

        XCTAssertEqual(result, 1)
    }

    func test_ThreeModels_OneItemInSectionZero() {

        let models = MockGenerator.createArticles(3)
        sut = HomeViewModel(article: models)
        let result = sut.numberOfItems(in: 0)

        XCTAssertEqual(result, 3)
    }

    func test_ThreeModels_ZeroItemsInSectionOne() {

        let models = MockGenerator.createArticles(3)
        sut = HomeViewModel(article: models)
        let result = sut.numberOfItems(in: 1)

        XCTAssertEqual(result, 0)
    }

    func test_ThreeModels_HasItemAtIndexPathZero() {

        let models = MockGenerator.createArticles(3)
        sut = HomeViewModel(article: models)
        let zero = IndexPath(row: 0, section: 0)
        let result = sut.cellViewModel(at: zero)

        XCTAssertNotNil(result)
    }

    func test_ThreeModels_ZeroItemsInNegativeSection() {

        let models = MockGenerator.createArticles(3)
        sut = HomeViewModel(article: models)
        let result = sut.numberOfItems(in: -1)

        XCTAssertEqual(result, 0)
    }

    func test_ThreeModels_NoItemAtNegativeSection() {

        let models = MockGenerator.createArticles(3)
        sut = HomeViewModel(article: models)
        let negative = IndexPath(row: 0, section: -1)
        let result = sut.cellViewModel(at: negative)

        XCTAssertNil(result)
    }

    func test_ThreeModels_NoItemAtNegativeRow() {

        let models = MockGenerator.createArticles(3)
        sut = HomeViewModel(article: models)
        let negative = IndexPath(row: -1, section: 0)
        let result = sut.cellViewModel(at: negative)

        XCTAssertNil(result)
    }

    // MARK: - Update
    func test_Update_HasSection() {

        let updateVM = expectation(description: "Update ViewModel")
        sut = HomeViewModel()
        sut.update { updateVM.fulfill() }
        wait(for: [updateVM], timeout: 1.0)
        let result = sut.numberOfSections

        XCTAssertGreaterThan(result, 0)
    }

    func test_Update_HasRowsInFirstSection() {

        let updateVM = expectation(description: "Update ViewModel")
        sut = HomeViewModel()
        sut.update { updateVM.fulfill() }
        wait(for: [updateVM], timeout: 1.0)
        let result = sut.numberOfItems(in: 0)

        XCTAssertGreaterThan(result, 0)

    }

    func test_Update_HasItem() {

        let updateVM = expectation(description: "Update ViewModel")
        sut = HomeViewModel()
        sut.update { updateVM.fulfill() }
        wait(for: [updateVM], timeout: 1.0)
        let result = sut.cellViewModel(at: IndexPath(row: 0, section: 0))

        XCTAssertNotNil(result)

    }

    // MARK: Size For Item
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
        sut = HomeViewModel(article: models)
        let size = CGSize(width: 320, height: 100)
        let indexPath = IndexPath(item: 0, section: 0)

        let result = sut.sizeForItem(at: indexPath, given: size)

        XCTAssertNotEqual(result, .zero)
    }

    func test_SingleModel_SectionOneItemZero_SizeZero() {

        let models = MockGenerator.createArticles(1)
        sut = HomeViewModel(article: models)
        let size = CGSize(width: 320, height: 100)
        let indexPath = IndexPath(item: 0, section: 1)

        let result = sut.sizeForItem(at: indexPath, given: size)

        XCTAssertEqual(result, .zero)
    }

    func test_SingleModel_NegativeIndexPath_SizeZero() {

        let models = MockGenerator.createArticles(1)
        sut = HomeViewModel(article: models)
        let size = CGSize(width: 320, height: 100)
        let indexPath = IndexPath(item: 0, section: -1)

        let result = sut.sizeForItem(at: indexPath, given: size)

        XCTAssertEqual(result, .zero)
    }

    // MARK: - Did Select Item At IndexPath
    // MARK: - Did Select Context Action
    // MARK: - Will Select Context Action
}
