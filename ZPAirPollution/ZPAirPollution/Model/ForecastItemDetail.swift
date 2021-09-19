//
//  ForecastItemDetail.swift
//  ZPAirPollution
//
//  Created by Daniel on 19.09.21.
//

import Foundation

protocol ForecastItemDetailModel {
    var co: Float { get }
    var no: Float { get }
    var no2: Float { get }
    var o3: Float { get }
    var so2: Float { get }
    var pm2_5: Float { get }
    var pm10: Float { get }
    var nh3: Float { get }
}

struct ForecastItemDetail : ForecastItemDetailModel {
    let co: Float
    let no: Float
    let no2: Float
    let o3: Float
    let so2: Float
    let pm2_5: Float
    let pm10: Float
    let nh3: Float
}

extension ForecastItemDetail : Decodable {
    
}
