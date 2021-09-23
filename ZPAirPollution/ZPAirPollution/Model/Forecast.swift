//
//  Forecast.swift
//  ZPAirPollution
//
//  Created by Daniel on 19.09.21.
//

import Foundation

protocol ForecastModel {
    var items: [ForecastItemModel] { get }
}

extension ForecastModel {
    var first: ForecastItemModel? {
        return items.first
    }
}

struct Forecast : ForecastModel{
    let items: [ForecastItemModel]
}

extension Forecast : Decodable {
    enum CodingKeys : CodingKey {
        case list
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([ForecastItem].self, forKey: .list)
    }
}
