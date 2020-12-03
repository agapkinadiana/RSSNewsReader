//
//  Feed.swift
//  RSSNewsReader
//
//  Created by Diana Agapkina on 26.11.20.
//

import Foundation
import SwiftyXMLParser

struct Feed {
    let id: String
    let title: String
    var description: String
    let pubDate: String
    let link: String
}

// MARK: - Feed Parser

extension Feed {
    init(feed: XML.Accessor.Element) {
        id = feed["guid"].text ?? ""
        title = feed["title"].text ?? ""
        description = feed["description"].text ?? ""
        pubDate = feed["pubDate"].text ?? ""
        link = feed["link"].text ?? ""
    }
    
    static func parseRSSFeedItems(feeds: XML.Accessor) -> [Feed] {
        var rssFeeds = [Feed]()
        for feed in feeds {
            rssFeeds.append(Feed.init(feed: feed))
        }
        return rssFeeds
    }
}
