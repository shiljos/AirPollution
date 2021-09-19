//
//  ForecastPresenter.swift
//  ZPAirPollution
//
//  Created by Daniel on 19.09.21.
//

import Foundation


final class ForecastPresenter {
    weak var delegate: ForecastPresenterDelegate?
    private let apiService: WeatherApiServiceProtocol
    private var sectionedForecast: [(key: String, value: [ForecastItemModel])] = [] {
        didSet {
            delegate?.updateUI()
        }
    }

    var currentForecastItem: ForecastItemModel! = nil {
        didSet {
            delegate?.setCurrentForecastViewValues(String(describing: currentForecastItem.airQualityIndex),
                                                   currentForecastItem.formattedDate,
                                                   currentForecastItem.airQualityIndex.color)
        }
    }
    
    init(_ apiService: WeatherApiServiceProtocol = WeatherApiService()) {
        self.apiService = apiService
        
        getAirPollutionItems()
        getCurrentAirPollutionItem()
    }    

    func configureCell(_ cell: ForecastCell, _ indexPath: IndexPath) {
        let forecastItem = sectionedForecast[indexPath.section].value[indexPath.row]
        cell.displayForecast(airQualityIndex: String(describing: forecastItem.airQualityIndex),
                             hour: forecastItem.hourComponent,
                             color: forecastItem.airQualityIndex.color)
    }
    
    func getItemCount(for section: Int) -> Int {
        sectionedForecast[section].value.count
    }
    func getSectionCount() -> Int {
        sectionedForecast.count
    }
    
    func showSectionHeaderText(for section: Int) -> String {
        sectionedForecast[section].key
    }
    
    func getForecastDetail(for indexPath: IndexPath) {
        let airComponents = sectionedForecast[indexPath.section].value[indexPath.row].components
        delegate?.displayDetailView(withData: airComponents)
    }
    
    func getForecastDetailForCurrent() {
        let airComponents = currentForecastItem.components
        delegate?.displayDetailView(withData: airComponents)
    }
    
    func getAirPollutionItems() {
        apiService.getAirPollutionItems({ (forecastResponse) in
            self.sectionedForecast = Dictionary(grouping: forecastResponse.list, by: {$0.formattedDate}).map{$0}.sorted{$0.key.compare($1.key) == .orderedAscending}
        })
    }
    
    func getCurrentAirPollutionItem() {
        apiService.getCurrentAirPollutionItems({ (currentForecast) in
            self.currentForecastItem = currentForecast.first
        })
    }
}
