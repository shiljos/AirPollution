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

    private weak var delegate: ForecastPresenterDelegate?
    private let apiService: WeatherApiServiceProtocol
    private var sectionedForecast: [(key: String, value: [ForecastItemModel])]! = nil {
        didSet {
            delegate?.updateUI()
        }
    }

    private var currentForecast: ForecastItemModel! = nil {
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
        sectionedForecast?.count ?? 0
    }
    
    func numberOfRows(in section: Int) -> Int {
        sectionedForecast[section].value.count
    }
    
    func titleForHeader(in section: Int) -> String {
        sectionedForecast[section].key
    }
    
    func getForecastElement() -> ForecastElement {
        (String(describing: currentForecast.airQualityIndex),
         currentForecast.formattedDate,
         currentForecast.airQualityIndex.asColor)
    }
    
    func getForecastElement(for indexPath: IndexPath) -> ForecastElement {
        let forecastItem = sectionedForecast[indexPath.section].value[indexPath.row]
        return (String(describing: forecastItem.airQualityIndex),
                forecastItem.hourComponent,
                forecastItem.airQualityIndex.asColor)
    }
    
    func showForecastDetail(for indexPath: IndexPath) {
        let forecastDetail = sectionedForecast[indexPath.section].value[indexPath.row].detail
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
                print(error.localizedDescription)
            }
        })
    }
    
   private func getAirPollutionListItems() {
        let dateFormatter = getDateFormatter()
        getAirPollutionItems { forecastResponse in
            self.sectionedForecast = Dictionary(grouping: forecastResponse.items, by: {$0.formattedDate}).map{
                $0}.sorted{dateFormatter.date(from: $0.key)! < dateFormatter.date(from: $1.key)!}//{$0.key.compare($1.key) == .orderedAscending}
        }
    }
    
    private func getCurrentAirPollutionItem() {
        getAirPollutionItems(CurrentForecastEndpoint(), { (forecastReponse) in
            self.currentForecast = forecastReponse.first
        })
    }
    
    func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
    }
    
}
