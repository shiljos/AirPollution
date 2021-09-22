//
//  ForecastItemDetail.swift
//  ZPAirPollution
//
//  Created by Daniel on 19.09.21.
//

import Foundation

protocol ForecastItemDetailModel {
    var co: Component { get }
    var no: Component { get }
    var no2: Component { get }
    var o3: Component { get }
    var so2: Component { get }
    var pm2_5: Component { get }
    var pm10: Component { get }
    var nh3: Component { get }
    
    func components() -> [(description: String, value: String)]
}

protocol ForecastItemComponentProtocol {
    var valueWithUnit: String { get }
}

typealias Component = ForecastItemComponentProtocol & CustomStringConvertible

enum ForecastItemComponent : Component  {
    
    case co(Float)
    case no(Float)
    case no2(Float)
    case o3(Float)
    case so2(Float)
    case pm2_5(Float)
    case pm10(Float)
    case nh3(Float)
    
    var description: String {
        switch self {
            case .co:
               return "CO (Carbon monoxide)"
            case .no:
               return "NO (Nitrogen monoxide)"
            case .no2:
               return "NO2 (Nitrogen dioxide)"
            case .o3:
               return "O3 (Ozone)"
            case .so2:
               return "SO2 (Sulphur dioxide)"
            case .pm2_5:
               return "PM2.5 (Fine particles matter)"
            case .pm10:
               return "PM10 (Coarse particulate matter)"
            case .nh3:
               return "NH3 (Ammonia)"

        }
    }
    
    var valueWithUnit: String {
        switch self {
            case .co(let value):
               return "\(value) μg/m3"
            case .no(let value):
                return "\(value) μg/m3"
            case .no2(let value):
                return "\(value) μg/m3"
            case .o3(let value):
                return "\(value) μg/m3"
            case .so2(let value):
                return "\(value) μg/m3"
            case .pm2_5(let value):
                return "\(value) μg/m3"
            case .pm10(let value):
                return "\(value) μg/m3"
            case .nh3(let value):
                return "\(value) μg/m3"

        }
    }
}

struct ForecastItemDetail : ForecastItemDetailModel {
    
    let co: Component
    let no: Component
    let no2: Component
    let o3: Component
    let so2: Component
    let pm2_5: Component
    let pm10: Component
    let nh3: Component
    
    func components() -> [(description: String, value: String)] {
        [co, no, no2, o3, so2, pm2_5, pm10, nh3].map({ (description: String(describing: $0), value: $0.valueWithUnit) })
    }
}

extension ForecastItemDetail : Decodable {
    enum CodingKeys : String, CodingKey {
        case co, no, no2, o3, so2, pm2_5, pm10, nh3
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let coValue = try container.decode(Float.self, forKey: .co)
        self.co = ForecastItemComponent.co(coValue)

        let noValue = try container.decode(Float.self, forKey: .no)
        self.no = ForecastItemComponent.no(noValue)

        let no2Value = try container.decode(Float.self, forKey: .no2)
        self.no2 = ForecastItemComponent.no2(no2Value)

        let o3Value = try container.decode(Float.self, forKey: .o3)
        self.o3 = ForecastItemComponent.o3(o3Value)

        let so2Value = try container.decode(Float.self, forKey: .so2)
        self.so2 = ForecastItemComponent.so2(so2Value)

        let pm2_5Value = try container.decode(Float.self, forKey: .pm2_5)
        self.pm2_5 = ForecastItemComponent.pm2_5(pm2_5Value)

        let pm10Value = try container.decode(Float.self, forKey: .pm10)
        self.pm10 = ForecastItemComponent.pm10(pm10Value)

        let nh3Value = try container.decode(Float.self, forKey: .nh3)
        self.nh3 = ForecastItemComponent.nh3(nh3Value)
    }
}
