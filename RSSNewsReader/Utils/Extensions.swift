//
//  Extensions.swift
//  RSSNewsReader
//
//  Created by Diana Agapkina on 27.11.20.
//

import Foundation
import WebKit

extension String {
    func removeHtmlTags() -> String {
        return self
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&laquo;", with: "«")
            .replacingOccurrences(of: "&raquo;", with: "»")
            .replacingOccurrences(of: "&mdash;", with: "—")
    }

    func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "MMM dd, HH:mm"
        let dateFormatted = dateFormatter.string(from: date)
        return dateFormatted
    }
}

extension WKWebView {
    func loadURL(_ urlString: String?) {
        guard let urlString = urlString else { return }
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}

extension Notification.Name {
    static let OnFeedUpdated = Notification.Name("OnFeedUpdated")
}
