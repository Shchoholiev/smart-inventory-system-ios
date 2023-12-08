//
//  ServiceBase.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/3/23.
//

import Foundation


class ServiceBase {
    
    let baseUrl: String
    
    init(url: String) {
        baseUrl = url
    }
    
    func convertUTCDateToLocalDateString(utcDate: Date, dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .medium) -> String {
        let localDateFormatter = DateFormatter()
        localDateFormatter.dateStyle = dateStyle
        localDateFormatter.timeStyle = timeStyle
        localDateFormatter.locale = Locale.current
        localDateFormatter.timeZone = TimeZone.current

        return localDateFormatter.string(from: utcDate)
    }
}
