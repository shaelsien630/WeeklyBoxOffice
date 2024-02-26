//
//  Formatter.swift
//  WeeklyBoxOffice
//
//  Created by 최서희 on 2/23/24.
//

import Foundation

extension Date {
    static var lastWeek: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    }
    
    func toString(_ format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
}

extension String {
    func asDate(format: DateFormat = .yyyyMMddHypen) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.date(from: self)
    }
}

extension Int {
    
    func numberFormatter() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
}

enum DateFormat: String {
    case yyyyMMdd = "yyyyMMdd"
    case yyyyMMddDot = "yyyy.MM.dd"
    case yyyyMMddHypen = "yyyy-MM-dd"
}
