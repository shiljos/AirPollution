//
//  WeatherApiService.swift
//  ZPAirPollution
//
//  Created by Daniel on 18.09.21.
//

import Foundation

enum Endpoint {
    case current
    case list
}


protocol WeatherApiServiceProtocol {
    func getAirPollutionItems(_ completion: @escaping (Result<ForecastModel, Error>) -> Void)
}

final class WeatherApiService: WeatherApiServiceProtocol {
    private let urlSession = URLSession(configuration: .default)
    let currentUrlString = "https://api.openweathermap.org/data/2.5/air_pollution?lat=48.13743&lon=11.57549&appid=034245a71302fc7bd2e4a609e702463a"
    let forecastUrlString = "https://api.openweathermap.org/data/2.5/air_pollution/forecast?lat=48.13743&lon=11.57549&appid=034245a71302fc7bd2e4a609e702463a"

    var endpoint: Endpoint? {
        didSet(newEndpoint) {
            if newEndpoint == .current {
                urlString = currentUrlString
            } else {
                urlString = forecastUrlString
            }
        }
    }
    var urlString = ""
    
    func getAirPollutionItems(_ completion: @escaping (Result<ForecastModel, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            do {
                let forecastItems = try JSONDecoder().decode(Forecast.self, from: data)
                completion(.success(forecastItems))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
