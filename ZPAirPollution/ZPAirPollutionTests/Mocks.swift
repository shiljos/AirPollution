//
//  Mocks.swift
//  ZPAirPollutionTests
//
//  Created by Daniel on 22.09.21.
//

import XCTest
@testable import ZPAirPollution

struct MockAirQuality: AirQuality {
    var description: String
    var asColor: UIColor
}

struct MockForecastItem : ForecastItemModel {
    var airQualityIndex: AirQuality
    var date: Date
    var detail: ForecastItemDetailModel
}

struct MockComponent : Component {
    var description: String
    var valueWithUnit: String
}

struct MockForecastItemDetail : ForecastItemDetailModel {
    var co: Component
    var no: Component
    var no2: Component
    var o3: Component
    var so2: Component
    var pm2_5: Component
    var pm10: Component
    var nh3: Component
    
    func components() -> [(description: String, value: String)] {
        [no2, so2, o3].map{(description: $0.description, value: $0.valueWithUnit)}
    }
}

struct MockForecast : ForecastModel {
    var items: [ForecastItemModel]
    
    static func getMockForecastItems() -> [ForecastItemModel] {
        mockForecastItems
    }
}

let mockForecastItems: [MockForecastItem] = [
    MockForecastItem(airQualityIndex: MockAirQuality(description: "aqi1", asColor: .green),
                     date: Date(timeIntervalSince1970: 1632538800),
                     detail: MockForecastItemDetail(co: MockComponent(description: "mock component", valueWithUnit: "14.3 μg/m3"), no: MockComponent(description: "mock component", valueWithUnit: "154.33 μg/m3"), no2: MockComponent(description: "mock component", valueWithUnit: "14.3 μg/m3"), o3: MockComponent(description: "mock component", valueWithUnit: "124.33 μg/m3"), so2: MockComponent(description: "mock component", valueWithUnit: "179.34 μg/m3"), pm2_5: MockComponent(description: "mock component", valueWithUnit: "18.3 μg/m3"), pm10: MockComponent(description: "mock component", valueWithUnit: "414.354 μg/m3"), nh3: MockComponent(description: "mock component", valueWithUnit: "514.3 μg/m3"))),
    MockForecastItem(airQualityIndex: MockAirQuality(description: "aqi2", asColor: .yellow),
                     date: Date(timeIntervalSince1970: 1632646800),
                     detail: MockForecastItemDetail(co: MockComponent(description: "mock component", valueWithUnit: "14.3 μg/m3"), no: MockComponent(description: "mock component", valueWithUnit: "14.3 μg/m3"), no2: MockComponent(description: "mock component", valueWithUnit: "14.3124 μg/m3"), o3: MockComponent(description: "mock component", valueWithUnit: "14.3124 μg/m3"), so2: MockComponent(description: "mock component", valueWithUnit: "124.3124 μg/m3"), pm2_5: MockComponent(description: "mock component", valueWithUnit: "14.3124 μg/m3"), pm10: MockComponent(description: "mock component", valueWithUnit: "914.3124 μg/m3"), nh3: MockComponent(description: "mock component", valueWithUnit: "104.312 μg/m3"))),
    MockForecastItem(airQualityIndex: MockAirQuality(description: "aqi3", asColor: .red),
                     date: Date(timeIntervalSince1970: 1632650400),
                     detail: MockForecastItemDetail(co: MockComponent(description: "mock component", valueWithUnit: "14.3 μg/m3"), no: MockComponent(description: "mock component", valueWithUnit: "140.3 μg/m3"), no2: MockComponent(description: "mock component", valueWithUnit: "16.43 μg/m3"), o3: MockComponent(description: "mock component", valueWithUnit: "14.3124 μg/m3"), so2: MockComponent(description: "mock component", valueWithUnit: "15.3ra μg/m3"), pm2_5: MockComponent(description: "mock component", valueWithUnit: "214.3 μg/m3"), pm10: MockComponent(description: "mock component", valueWithUnit: "124.3 μg/m3"), nh3: MockComponent(description: "mock component", valueWithUnit: "154.3 μg/m3")))
]

class MockAPIService : WeatherApiServiceProtocol {
    func getAirPollutionItems(_ endpoint: Endpoint, _ completion: @escaping (Result<ForecastModel, Error>) -> Void) {
            completion(Result.success(MockForecast(items: mockForecastItems)))
    }
}

class MockForecastViewController : ForecastPresenterDelegate {
    var uiUpdated = false
    var currentViewUpdated = false
    var displayedItemDetailComponents: [ForecastDetailElement] = []
    
    func updateUI() {
        uiUpdated = true
    }
    
    func updateCurrentView(with forecastElement: ForecastElement) {
        currentViewUpdated = true
    }
    
    func displayDetailView(with forecastItemDetailComponents: [ForecastDetailElement]) {
        displayedItemDetailComponents = forecastItemDetailComponents
    }
}
