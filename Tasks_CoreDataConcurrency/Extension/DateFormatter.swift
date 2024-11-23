//
//  DateFormatter.swift
//  Tasks_CoreDataConcurrency
//
//  Created by Aleksandr Bochkarev on 11/21/24.
//

import Foundation

extension DateFormatter {
    static func convertDateToString(from date: Date?) -> String {
        guard let date = date else {
            return String(localized: "Date_not_found")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
}
