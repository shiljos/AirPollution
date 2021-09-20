//
//  AirQualityModel.swift
//  ZPAirPollution
//
//  Created by Daniel on 18.09.21.
//

import UIKit

enum AirQualityLevel: Int, CustomStringConvertible, Decodable {
    case good = 1, fair, moderate, poor, veryPoor
    
    var description: String {
        switch self {
            case .good:
                return "Good"
            case .fair:
                return "Fair"
            case .moderate:
                return "Moderate"
            case .poor:
                return "Poor"
            case .veryPoor:
                return "Very Poor"
        }
    }
    
    var color: UIColor {
        switch self {
            case .good:
                return .green
            case .fair:
                return .green
            case .moderate:
                return .yellow
            case .poor:
                return .red
            case .veryPoor:
                return .red
        }
    }
}

protocol ForecastItemModel {
    var airQualityIndex: AirQualityLevel { get }
    var unixDate: Double { get }
    var components: ForecastItemDetailModel { get }
}
extension ForecastItemModel {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: unixDate)
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let dateAsFormattedString = dateFormatter.string(from: date)
        
        return dateAsFormattedString
    }
    
    var hourComponent: String {
        let formatter = DateFormatter()
        let date = Date(timeIntervalSince1970: unixDate)
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "hh a"
        let hourString = formatter.string(from: date)
        return hourString
    }
}

struct ForecastItem : ForecastItemModel {
    let airQualityIndex: AirQualityLevel
    let unixDate: Double
    let components: ForecastItemDetailModel
}

extension ForecastItem : Decodable {
    enum CodingKeys: String, CodingKey {
        case main
        case unixDate = "dt"
        case components
        
        enum AirQualityCodingKeys: String, CodingKey {
            case aqi
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mainContainer = try container.nestedContainer(keyedBy: CodingKeys.AirQualityCodingKeys.self, forKey: .main)
        airQualityIndex = try mainContainer.decode(AirQualityLevel.self, forKey: .aqi)
        //let unixDate = try container.decode(Double.self, forKey: .unixDate)
        unixDate = try container.decode(Double.self, forKey: .unixDate)
        //date = Date(timeIntervalSince1970: unixDate)
        components = try container.decode(ForecastItemDetail.self, forKey: .components)
    }
}




