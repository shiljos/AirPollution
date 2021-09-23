//
//  ForecastPresenter.swift
//  ZPAirPollution
//
//  Created by Daniel on 19.09.21.
//

import Foundation

protocol ForecastPresenterProtocol {
    func fetchData()
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func titleForHeader(in section: Int) -> String
    func setPresenterDelegate(_ presenterDelegate: ForecastPresenterDelegate)
    func getForecastElement(for indexPath: IndexPath) -> ForecastElement
    func showForecastDetail(for indexPath: IndexPath)
    func showForecastDetail()
}

final class ForecastPresenter : ForecastPresenterProtocol {
    
    private let apiService: WeatherApiServiceProtocol
    private(set) weak var delegate: ForecastPresenterDelegate?
    private(set) var sectionedForecast: [(key: String, value: [ForecastItemModel])] = [] {
        didSet {
            delegate?.updateUI()
        }
    }
    private(set) var currentForecast: ForecastItemModel! = nil {
        didSet {
            delegate?.updateCurrentView(with: getForecastElement())
        }
    }
    
    init(_ apiService: WeatherApiServiceProtocol = WeatherApiService()) {
        self.apiService = apiService
    }
    
    func setPresenterDelegate(_ presenterDelegate: ForecastPresenterDelegate) {
        delegate = presenterDelegate
    }
    
    func numberOfSections() -> Int {
        sectionedForecast.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        sectionedForecast[section].1.count
    }
    
    func titleForHeader(in section: Int) -> String {
        sectionedForecast[section].0
    }
    
    func getForecastElement() -> ForecastElement {
        (String(describing: currentForecast.airQualityIndex),
         currentForecast.formattedDate,
         currentForecast.airQualityIndex.asColor)
    }
    
    func getForecastElement(for indexPath: IndexPath) -> ForecastElement {
        let forecastItem = sectionedForecast[indexPath.section].1[indexPath.row]
        return (String(describing: forecastItem.airQualityIndex),
                forecastItem.hourComponent,
                forecastItem.airQualityIndex.asColor)
    }
    
    func showForecastDetail(for indexPath: IndexPath) {
        let forecastDetail = sectionedForecast[indexPath.section].1[indexPath.row].detail
        delegate?.displayDetailView(with: forecastDetail.components())
    }
    
    func showForecastDetail() {
        let forecastDetail = currentForecast.detail
        delegate?.displayDetailView(with: forecastDetail.components())
    }
}

extension ForecastPresenter {
    func fetchData() {
        getAirPollutionListItems()
        getCurrentAirPollutionItem()
    }
    
    private func getAirPollutionItems(_ endpoint: Endpoint = ForecastEndpoint(), _ completion: @escaping (ForecastModel) -> Void) {
        apiService.getAirPollutionItems(endpoint, { (result) in
            switch result {
            case .success(let forecastResponse):
                completion(forecastResponse)
            case .failure(let error):
                self.handleError(error)
            }
        })
    }
    
   private func getAirPollutionListItems() {
        getAirPollutionItems { forecastResponse in
            self.sectionedForecast = Dictionary(grouping: forecastResponse.items, by: { $0.formattedDate })
                                                .sorted(by: { self.compareAsc($0.key, $1.key) })
                                                .map{ $0 }
        }
    }
    
    private func getCurrentAirPollutionItem() {
        getAirPollutionItems(CurrentForecastEndpoint(), { (forecastReponse) in
            self.currentForecast = forecastReponse.first
        })
    }
    
    private func compareAsc(_ dateString1: String, _ dateString2: String) -> Bool {
        let formatter = DateFormatter()
        return formatter.shortDate(from: dateString1) < formatter.shortDate(from: dateString2)
    }
    
    private func handleError(_ error: Error) {
        switch error {
            case URLError.cannotLoadFromNetwork, URLError.networkConnectionLost, URLError.notConnectedToInternet:
                showOfflineView()
            case ServiceError.unexpectedResponse:
                showUnexpectedEmptyDataAlertView()
            case is URLError:
                showNetworkErrorView()
            default:
                print(error.localizedDescription)
        }
    }
    
    func showOfflineView() {}
    
    func showNetworkErrorView() {}
    
    func showUnexpectedEmptyDataAlertView() {}
}
