//
//  Endpoint.swift
//  ZPAirPollution
//
//  Created by Daniel on 22.09.21.
//

import Foundation


protocol Endpoint {
    func makeURL() -> URL?
}

struct ForecastEndpoint : Endpoint {
    private let urlString: String = "https://api.openweathermap.org/data/2.5/air_pollution/forecast?lat=48.13743&lon=11.57549&appid=034245a71302fc7bd2e4a609e702463a"
    
    func makeURL() -> URL? {
        URL(string: urlString)
    }
}

struct CurrentForecastEndpoint : Endpoint {
    private let urlString: String = "https://api.openweathermap.org/data/2.5/air_pollution?lat=48.13743&lon=11.57549&appid=034245a71302fc7bd2e4a609e702463a"
    
    func makeURL() -> URL? {
        URL(string: urlString)
    }
}
