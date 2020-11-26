//
//  Feed.swift
//  RSSNewsReader
//
//  Created by Diana Agapkina on 26.11.20.
//

import Foundation
import SwiftyXMLParser

struct Feed {
    let id : String
    let title: String
    let description: String
    let pubDate : String
    let link : String
    let isSaved: Bool
    
    // MARK: - Helper Functions
    
    func formatDate(newsDate: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "E, d MMM yyyy HH:mm:ss z"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.locale = Locale(identifier: "ru_RU")
        dateFormatterPrint.dateFormat = "d MMM, HH:mm"
        
        if let date = dateFormatterGet.date(from: newsDate) {
            return dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
        return ""
    }
}

// MARK: - Feed Parser

extension Feed {
    init(feed: XML.Accessor.Element) {
        id = feed["guid"].text ?? ""
        title = feed["title"].text ?? ""
        description = feed["description"].text ?? ""
        pubDate = feed["pubDate"].text ?? ""
        link = feed["link"].text ?? ""
        isSaved = false
    }
    
    static func parseRSSFeedItems(feeds: XML.Accessor) -> [Feed] {
        var rssFeeds = [Feed]()
        for feed in feeds {
            rssFeeds.append(Feed.init(feed: feed))
        }
        return rssFeeds
    }
}
