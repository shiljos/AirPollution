//
//  DateFormatter.swift
//  ZPAirPollution
//
//  Created by Daniel on 22.09.21.
//

import Foundation

extension DateFormatter {

    func shortDate(from value: String) -> Date! {
        dateStyle = .short
        return date(from: value)
    }
    
    func shortDate(from value: Date) -> String {
        dateStyle = .short
        return string(from: value)
    }
    
    func fromUnixDate(_ value: TimeInterval) -> Date! {
        let dateTime = Date(timeIntervalSince1970: value)
        dateStyle = .full
        timeStyle = .full
        let dateString = string(from: dateTime)
        return date(from: dateString)
    }
    
    func formattedHour(from date: Date) -> String {
        dateFormat = "hh a"
        return string(from: date)
    }
}
