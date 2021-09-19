//
//  Forecast.swift
//  ZPAirPollution
//
//  Created by Daniel on 19.09.21.
//

import Foundation

protocol ForecastModel {
    var list: [ForecastItem] { get }
    /*var items: [(key: String, value: [ForecastItem])] { get }
    subscript(indexPath: IndexPath) -> ForecastItem { get }
    subscript(index: Int) -> (key: String, value: [ForecastItem]) { get }
    mutating func current() -> ForecastItem?
    */
}
extension ForecastModel {
    var count: Int {
        list.count
    }
    var first: ForecastItemModel? {
        return list.first
    }
}

struct Forecast : ForecastModel, Decodable  {

    //var items: [(key: String, value: [ForecastItem])]
    let list: [ForecastItem]
    /*
    subscript(indexPath: IndexPath) -> ForecastItem {
        return items[indexPath.section].value[indexPath.row]
    }
    
    subscript(index: Int) -> (key: String, value: [ForecastItem]) {
        return items[index]
    }
    
    mutating func current() -> ForecastItem? {
        items[0].value.first
    }
    */
}
/*
extension Forecast : Decodable {
    enum CodingKeys: String, CodingKey {
        case list
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([ForecastItem].self, forKey: .list)

    }
}
 */
/*
extension Forecast : Sequence, IteratorProtocol {
    mutating func next() -> ForecastItemModel? {
        var iterator = items.makeIterator()
        return iterator.next()
    }
}
*/
