//
//  SharedDateFormatter.swift
//  LiveRail
//
//  Created by Terran Kroft on 2/8/21.
//

import Foundation

class SharedDateFormatter {
    static let shared = SharedDateFormatter()
    
    private let taipeiFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone(identifier: "Asia/Taipei")
        return df
    }()
    
    private let hourFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        df.timeZone = TimeZone(identifier: "Asia/Taipei")

        return df
    }()
    
    private let serverFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "EEE, dd MMM yyyy HH:mm:ww zzz"
        df.locale = Locale(identifier: "en_US")
        df.timeZone = TimeZone(secondsFromGMT: 0)
        return df
    }()
    
    func taiwanTZString(from date: Date) -> String {
        return taipeiFormatter.string(from: date)
    }
    
    func date(from timeString: String) -> Date? {
        return hourFormatter.date(from: timeString)
    }
    
    func serverDate(from date: Date) -> String {
        return serverFormatter.string(from: date)
    }
}
