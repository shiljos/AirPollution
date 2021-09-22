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
    //private var sectionedForecast: [(key: String, value: [ForecastItemModel])] = [] {//! = nil {
    private(set) var sectionedForecast: [[ForecastItemModel]]! = nil {
        didSet {
            delegate?.updateUI()
        }
    }
    private(set) var sectionKeys: [String]! = nil
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
        //sectionedForecast.count
        sectionKeys.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        sectionedForecast[section].count
        //sectionedForecast[section].value.count
    }
    
    func titleForHeader(in section: Int) -> String {
        sectionKeys[section]
        //sectionedForecast[section].key
    }
    
    func getForecastElement() -> ForecastElement {
        (String(describing: currentForecast.airQualityIndex),
         currentForecast.formattedDate,
         currentForecast.airQualityIndex.asColor)
    }
    
    func getForecastElement(for indexPath: IndexPath) -> ForecastElement {
        let forecastItem = sectionedForecast[indexPath.section][indexPath.row]
        return (String(describing: forecastItem.airQualityIndex),
                forecastItem.hourComponent,
                forecastItem.airQualityIndex.asColor)
    }
    
    func showForecastDetail(for indexPath: IndexPath) {
        let forecastDetail = sectionedForecast[indexPath.section][indexPath.row].detail
        delegate?.displayDetailView(with: forecastDetail.components())
    }
    
    func showForecastDetail() {
        let forecastDetail = currentForecast.detail
        delegate?.displayDetailView(with: forecastDetail.components())
    }
}

extension ForecastPresenter {
    func fetchData() {
        sectionKeys = []
        sectionedForecast = []
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
        getAirPollutionItems { [unowned self] forecastResponse in
            sectionedForecast = Dictionary(grouping: forecastResponse.items, by: { $0.formattedDate })
                                          .sorted(by: { compareAsc($0.key, $1.key) })
                                          .map{ sectionKeys.append(($0.key)); return $0.value }
        }
    }
    
    private func getCurrentAirPollutionItem() {
        getAirPollutionItems(CurrentForecastEndpoint(), { [unowned self] (forecastReponse) in
            currentForecast = forecastReponse.first
        })
    }
    
    private func compareAsc(_ v1: String, _ v2: String) -> Bool {
        let formatter = DateFormatter()
        return formatter.shortDate(from: v1) < formatter.shortDate(from: v2)
    }
    
    func handleError(_ error: Error) {
        switch error {
            case URLError.cannotLoadFromNetwork, URLError.networkConnectionLost, URLError.notConnectedToInternet:
                showOfflineView()
            case ServiceError.unexpectedResponse://let error as ServiceError where error == .unexpectedResponse:
                showUnexpectedDataAlertView()
            case is URLError:
                showNetworkErrorView()
            default:
                print(error.localizedDescription)
        }
    }
    
    func showOfflineView() {}
    
    func showNetworkErrorView() {}
    
    func showUnexpectedDataAlertView() {}
}
