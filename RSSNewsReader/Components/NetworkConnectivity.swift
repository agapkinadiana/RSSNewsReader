//
//  NetworkConnectivity.swift
//  RSSNewsReader
//
//  Created by Diana Agapkina on 1.12.20.
//

import Foundation
import Alamofire

class NetworkConnectivity {
    static let shared = NetworkConnectivity()
    private let networkReachabilityManager = NetworkReachabilityManager()
    
    func listenForNetworkAvailability(succesHandler: @escaping (()->Void), errorHandler: @escaping (()->Void)) {
        networkReachabilityManager?.startListening { status in
            switch status {
            case .notReachable, .unknown:
                errorHandler()
            case .reachable(.ethernetOrWiFi), .reachable(.cellular):
                succesHandler()
            }
        }
    }
}
