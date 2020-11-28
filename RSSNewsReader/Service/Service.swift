//
//  Service.swift
//  RSSNewsReader
//
//  Created by Diana Agapkina on 26.11.20.
//

import Alamofire
import SwiftyXMLParser

let API_URL = "https://alfabank.ru/_/rss/_rss.html?subtype=1&category=2&city=21"

struct Service {
    static let shared = Service()
    
    func fetchFeeds(completion: @escaping (AFResult<[Feed]>) -> ()) {
        AF.request(API_URL)
            .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                if let err = dataResponse.error {
                    completion(.failure(err))
                    return
                }
                
                guard let data = dataResponse.data else { return }
                let obj = XML.parse(data)["rss"]
                let items = obj["channel"]["item"]
                let rssFeeds = Feed.parseRSSFeedItems(feeds: items)
                completion(.success(rssFeeds))
            }
    }
}
