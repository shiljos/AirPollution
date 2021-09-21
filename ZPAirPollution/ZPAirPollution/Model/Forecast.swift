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
    var count: Int {
        items.count
    }
    var first: ForecastItemModel? {
        return items.first
    }
}

struct Forecast : ForecastModel{
    let items: [ForecastItemModel]
}

extension Forecast : Decodable {
    enum CodingKeys : String, CodingKey {
        case items = "list"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([ForecastItem].self, forKey: .items)
    }
}
