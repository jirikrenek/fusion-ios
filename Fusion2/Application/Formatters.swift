//
//  Formatters.swift
//  Tipli
//
//  Created by Petr Skornok on 28/11/2019.
//  Copyright © 2019 Tipli s.r.o. All rights reserved.
//

import UIKit

struct Formatters {

    // MARK: - Date API

    static let dateApiFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Calendar.current.locale
        formatter.timeZone = TimeZone.current
        return formatter
    }()

    static func dateFormatter(format: String, from date: Date) -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = format
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatterPrint.string(from: date)
    }

    static func getDateString(forDate date: Date?,
                              dateStyle: DateFormatter.Style = .medium,
                              timeStyle: DateFormatter.Style = .none,
                              timezone: TimeZone = TimeZone.current,
                              doesRelativeDateFormatting: Bool = false) -> String? {
        guard let date = date else {
            return nil
        }

        Formatters.dateFormatter.dateStyle = dateStyle
        Formatters.dateFormatter.timeStyle = timeStyle
        Formatters.dateFormatter.timeZone = timezone
        Formatters.dateFormatter.doesRelativeDateFormatting = doesRelativeDateFormatting
        return Formatters.dateFormatter.string(from: date)
    }

 
}
