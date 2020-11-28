//
//  FeedWebViewController.swift
//  RSSNewsReader
//
//  Created by Diana Agapkina on 29.11.20.
//

import UIKit
import WebKit

class FeedWebViewController: UIViewController {
    
    //MARK: - Properties
    
    private let webView = WKWebView()
    var urlString: String?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadURL(urlString)
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func loadURL(_ urlString: String?) {
        guard let urlString = urlString else { return }
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
