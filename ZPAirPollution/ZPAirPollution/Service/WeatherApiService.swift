//
//  WeatherApiService.swift
//  ZPAirPollution
//
//  Created by Daniel on 18.09.21.
//

import Foundation


protocol WeatherApiServiceProtocol {
    func getAirPollutionItems(_ endpoint: Endpoint, _ completion: @escaping (Result<ForecastModel, Error>) -> Void)
}

final class WeatherApiService : WeatherApiServiceProtocol {

    func getAirPollutionItems(_ endpoint: Endpoint, _ completion: @escaping (Result<ForecastModel, Error>) -> Void) {
        guard let url = endpoint.makeURL() else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, !data.isEmpty else {
                completion(.failure(ServiceError.unexpectedResponse))
                return
            }
            
            do {
                let forecastItems = try JSONDecoder().decode(Forecast.self, from: data)
                completion(.success(forecastItems))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

enum ServiceError : Error {
    case unexpectedResponse
    
    static func ~=(lhs: Error, rhs: ServiceError) -> Bool {
        return (lhs as? ServiceError) == rhs
    }
}

