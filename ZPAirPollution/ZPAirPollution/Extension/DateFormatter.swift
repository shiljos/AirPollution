//
//  DateFormatter.swift
//  ZPAirPollution
//
//  Created by Daniel on 22.09.21.
//

import Foundation

extension DateFormatter {
    
    func setFormat() {
        dateStyle = .short
        timeZone = TimeZone(identifier: "UTC")
    }

    func short(from value: String) -> Date! {
        setFormat()
        return date(from: value)
    }
    
    func short(from value: Date) -> String {
        setFormat()
        return string(from: value)
    }
    
    func formattedHour(from date: Date) -> String {
        timeZone = TimeZone(identifier: "UTC")
        dateFormat = "hh a"
        return string(from: date)
    }
}
