//
//  AirQualityModel.swift
//  ZPAirPollution
//
//  Created by Daniel on 18.09.21.
//

import UIKit

protocol AirQualityProtocol {
    var asColor: UIColor { get }
}

typealias AirQuality = AirQualityProtocol & CustomStringConvertible

enum AirQualityLevel : Int, AirQuality, Decodable {
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
    
    var asColor: UIColor {
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
    var airQualityIndex: AirQuality { get }
    var date: Date { get }
    var detail: ForecastItemDetailModel { get }
}

extension ForecastItemModel {
    var formattedDate: String {
        DateFormatter().shortDate(from: date)
    }
    
    var hourComponent: String {
        DateFormatter().formattedHour(from: date)
    }
}

struct ForecastItem : ForecastItemModel {
    let airQualityIndex: AirQuality
    let date: Date
    let detail: ForecastItemDetailModel
}

extension ForecastItem : Decodable {
    enum CodingKeys : CodingKey {
        case main
        case dt
        case components
        
        enum AirQualityCodingKeys : CodingKey {
            case aqi
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mainContainer = try container.nestedContainer(keyedBy: CodingKeys.AirQualityCodingKeys.self, forKey: .main)
        airQualityIndex = try mainContainer.decode(AirQualityLevel.self, forKey: .aqi)
        let unixDate = try container.decode(Double.self, forKey: .dt)
        date = DateFormatter().fromUnixDate(unixDate)
        detail = try container.decode(ForecastItemDetail.self, forKey: .components)
    }
}
