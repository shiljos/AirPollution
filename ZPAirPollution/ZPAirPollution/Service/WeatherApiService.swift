//
//  WeatherApiService.swift
//  ZPAirPollution
//
//  Created by Daniel on 18.09.21.
//

import Foundation

protocol WeatherApiServiceProtocol {
    func getAirPollutionItems(_ completion: @escaping (ForecastModel) -> Void)
    func getCurrentAirPollutionItems(_ completion: @escaping (ForecastModel) -> Void)
}

final class WeatherApiService: WeatherApiServiceProtocol {
    private let urlSession = URLSession(configuration: .default)
    let urlString = "https://api.openweathermap.org/data/2.5/air_pollution/forecast?lat=48.13743&lon=11.57549&appid=034245a71302fc7bd2e4a609e702463a"

    func getAirPollutionItems(_ completion: @escaping (ForecastModel) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        urlSession.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let forecastItems = try! JSONDecoder().decode(Forecast.self, from: data)
                completion(forecastItems)
            }
        }.resume()
    }
    
    func getCurrentAirPollutionItems(_ completion: @escaping (ForecastModel) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/air_pollution?lat=48.13743&lon=11.57549&appid=034245a71302fc7bd2e4a609e702463a") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        urlSession.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let forecastItems = try! JSONDecoder().decode(Forecast.self, from: data)
                completion(forecastItems)
            }
        }.resume()
    }
}
