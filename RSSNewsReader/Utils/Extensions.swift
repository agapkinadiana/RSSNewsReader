//
//  Extensions.swift
//  RSSNewsReader
//
//  Created by Diana Agapkina on 27.11.20.
//

import Foundation

extension String {
    func removeHtmlTags() -> String {
        return self
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "&[^;]+;", with: "", options: .regularExpression, range: nil)
    }

    func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        let dateFormatted = dateFormatter.string(from: date)
        return dateFormatted
    }
}
