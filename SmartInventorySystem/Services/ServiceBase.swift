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
    
    /// Converts a UTC date to a local date string based on the current locale and timezone settings.
    /// The format of the resulting date and time string is determined by the specified date and time styles.
    ///
    /// - Parameters:
    ///   - utcDate: The date in UTC that needs to be converted.
    ///   - dateStyle: The style to use for the date portion of the resulting string.
    ///                Defaults to `.medium`.
    ///   - timeStyle: The style to use for the time portion of the resulting string.
    ///                Defaults to `.medium`.
    ///
    /// - Returns: A localized date and time string representing the given UTC date.
    ///
    /// Usage Example:
    /// ```
    /// let utcDate = Date() // Assume this is a UTC date
    /// let localDateString = convertUTCDateToLocalDateString(utcDate: utcDate)
    /// ```
    func convertUTCDateToLocalDateString(utcDate: Date, dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .medium) -> String {
        let localDateFormatter = DateFormatter()
        localDateFormatter.dateStyle = dateStyle
        localDateFormatter.timeStyle = timeStyle
        localDateFormatter.locale = Locale.current
        localDateFormatter.timeZone = TimeZone.current

        return localDateFormatter.string(from: utcDate)
    }
}
