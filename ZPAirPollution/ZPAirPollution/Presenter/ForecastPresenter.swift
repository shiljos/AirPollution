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
        
        getAirPollutionListItems()
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
    
    func getAirPollutionListItems() {
        getAirPollutionItems { forecastResponse in
            self.sectionedForecast = Dictionary(grouping: forecastResponse.list, by: {$0.formattedDate}).map{$0}.sorted{self.compareDates($0.key, $1.key)}//{$0.key.compare($1.key) == .orderedAscending}
        }
    }
    
    func getAirPollutionItems(_ completion: @escaping (ForecastModel) -> ()) {
        apiService.getAirPollutionItems({ (result) in
            switch result {
            case .success(let forecastResponse):
                completion(forecastResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        })
    }
    
    func compareDates(_ v1: String, _ v2: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let firstDate = dateFormatter.date(from: v1),
           let secondDate = dateFormatter.date(from: v2) {
            return firstDate < secondDate
        }
        return false
    }
    
    func getCurrentAirPollutionItem() {
        getAirPollutionItems({ (forecastReponse) in
            self.currentForecastItem = forecastReponse.first
        })
    }
}
