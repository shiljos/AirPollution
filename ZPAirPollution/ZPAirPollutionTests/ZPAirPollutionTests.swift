//
//  ZPAirPollutionTests.swift
//  ZPAirPollutionTests
//
//  Created by Daniel on 18.09.21.
//

import XCTest
@testable import ZPAirPollution

final class ZPAirPollutionTests: XCTestCase {

    var presenter: ForecastPresenter!
    
    override func setUp() {
        presenter = ForecastPresenter(MockAPIService())
    }

    override func tearDown() {}
    
    func testInitPresenterIfDataStructuresEmptyOrNil() {
        XCTAssertNil(presenter.sectionedForecast)
        XCTAssertNil(presenter.sectionKeys)
        XCTAssertNil(presenter.currentForecast)
    }

    func testInitPresenterWithDataIfDataStructuresEmptyOrNil() {
        presenter.fetchData()
        XCTAssertTrue(!presenter.sectionedForecast.isEmpty)
        XCTAssertTrue(!presenter.sectionKeys.isEmpty)
        XCTAssertNotNil(presenter.currentForecast)
    }
    
    func testInitPresenterIfViewDelegateNil() {
        XCTAssertNil(presenter.delegate)
    }
    
    func testInitPresenterIfViewDelegateSet() {
        let mockVC = MockForecastViewController()
        presenter.setPresenterDelegate(mockVC)
        
        XCTAssertNotNil(presenter.delegate)
    }
    
    func testPresenterSectionedForecastCorrectlyMappedWithSectionKeys() {
        presenter.fetchData()
        
        XCTAssertEqual(presenter.sectionedForecast.count, presenter.sectionKeys.count)
        XCTAssertEqual(presenter.sectionKeys.count, 2)
    }
    
    func testPresenterSectionedForecastCorrectNumberOfItemsIfReload() {
        presenter.fetchData()
        presenter.fetchData()
        
        XCTAssertEqual(presenter.sectionedForecast.count, presenter.sectionKeys.count)
        XCTAssertEqual(presenter.sectionKeys.count, 2)
    }
    
    func testPresenterSectionedForecastCorrectNumberOfItems() {
        presenter.fetchData()

        XCTAssertEqual(presenter.numberOfSections(), 2)
        XCTAssertEqual(presenter.numberOfRows(in: 0), 1)
        XCTAssertEqual(presenter.numberOfRows(in: 1), 2)
    }
    
    func testPresenterCorrectHeaderNameForSection() {
        presenter.fetchData()
    
        XCTAssertEqual(presenter.titleForHeader(in: 0), "9/25/21")
        XCTAssertEqual(presenter.titleForHeader(in: 1), "9/26/21")
    }
    
    func testPresenterCorrectHeaderFromSectionKeys() {
        presenter.fetchData()
    
        XCTAssertEqual(presenter.titleForHeader(in: 0), presenter.sectionKeys[0])
        XCTAssertEqual(presenter.titleForHeader(in: 1), presenter.sectionKeys[1])
    }
    
    func testPresenterStructuresDataPassedForCurrent() {
        presenter.fetchData()
        let mockForecast = MockForecast().getMockForecastItems().first
        let mockForecastElement = (mockForecast?.airQualityIndex.description, mockForecast?.formattedDate, mockForecast?.airQualityIndex.asColor)
        
        XCTAssertEqual(presenter.getForecastElement().0, mockForecastElement.0)
        XCTAssertEqual(presenter.getForecastElement().1, mockForecastElement.1)
        XCTAssertEqual(presenter.getForecastElement().2, mockForecastElement.2)
    }
    
    func testPresenterStructuresDataPassedForIndexPath() {
        presenter.fetchData()
        let indexPath = IndexPath(row: 0, section: 1)
        let mockForecastElement = ("aqi2", "09 AM", UIColor.yellow)
        
        XCTAssertEqual(presenter.getForecastElement(for: indexPath).0, mockForecastElement.0)
        XCTAssertEqual(presenter.getForecastElement(for: indexPath).1, mockForecastElement.1)
        XCTAssertEqual(presenter.getForecastElement(for: indexPath).2, mockForecastElement.2)
    }
    
    func testPresenterStructureElementsOrderCorrect() {
        presenter.fetchData()
        let indexPath = IndexPath(row: 0, section: 1)
        let indexPathNext = IndexPath(row: 1, section: 1)
        let mockForecastElement = ("", "09 AM", UIColor.yellow)
        let mockForecastElementNext = ("", "10 AM", UIColor.yellow)
        
        XCTAssertEqual(presenter.getForecastElement(for: indexPath).1, mockForecastElement.1)
        XCTAssertEqual(presenter.getForecastElement(for: indexPathNext).1, mockForecastElementNext.1)
    }
    
    func testPresenterShowDetailCallBackForCurrent() {
        let mockVC = MockForecastViewController()
        presenter.setPresenterDelegate(mockVC)
        presenter.fetchData()
        
        presenter.showForecastDetail()
        XCTAssertTrue(!mockVC.displayedItemDetailComponents.isEmpty)
        
        let mockComponents = MockForecast().getMockForecastItems().first?.detail.components()
        XCTAssertEqual(mockVC.displayedItemDetailComponents.count, mockComponents!.count)
        for (index, component) in mockVC.displayedItemDetailComponents.enumerated() {
            XCTAssertEqual(component.0, mockComponents![index].0)
            XCTAssertEqual(component.1, mockComponents![index].1)
        }
    }
    
    func testPresenterCallsDelegateMethods() {
        let mockVC = MockForecastViewController()
        presenter.setPresenterDelegate(mockVC)
        presenter.fetchData()
        
        XCTAssertTrue(mockVC.uiUpdated)
        XCTAssertTrue(mockVC.currentViewUpdated)
    }
    
    func testUnexpectedResponseServiceError() {
        let apiService = ServiceErrorResponseMockAPIService()
        apiService.getAirPollutionItems { result in
            switch result {
                case .success(_):
                    XCTFail()
                case .failure(let error):
                    XCTAssertTrue(error is ServiceError)
                    XCTAssertEqual(error as? ServiceError, .unexpectedResponse)
            }
        }
    }
}
