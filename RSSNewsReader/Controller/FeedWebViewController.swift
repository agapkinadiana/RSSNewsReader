//
//  FeedWebViewController.swift
//  RSSNewsReader
//
//  Created by Diana Agapkina on 29.11.20.
//

import UIKit
import WebKit
import Alamofire

class FeedWebViewController: UIPageViewController {
    
    //MARK: - Properties
    
    private let webView = WKWebView()
    var feeds = [Feed]()
    var currentIndex = Int()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureGestureRecognizers()
        loadPage(for: currentIndex)
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureGestureRecognizers() {
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action:
                                                        #selector(swipeMade(_:)))
        leftRecognizer.direction = .left
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action:
                                                        #selector(swipeMade(_:)))
        rightRecognizer.direction = .right
        self.view.addGestureRecognizer(leftRecognizer)
        self.view.addGestureRecognizer(rightRecognizer)
    }
    
    func loadPage(for index: Int) {
        let link = feeds[index].link
        webView.loadURL(link)
    }
    
    // MARK: - Selectors
    
    @objc func swipeMade(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            print("DEBUG: left swipe made")
            currentIndex += 1
            if currentIndex == feeds.count {
                currentIndex = 0
            }
        }
        if sender.direction == .right {
            print("DEBUG: right swipe made")
            if currentIndex == 0 {
                currentIndex = feeds.count
            }
            currentIndex -= 1
        }
        loadPage(for: currentIndex)
    }
}
