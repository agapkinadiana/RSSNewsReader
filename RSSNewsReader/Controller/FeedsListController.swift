//
//  FeedsListController.swift
//  RSSNewsReader
//
//  Created by Diana Agapkina on 26.11.20.
//

import UIKit
import SnapKit

private let reuseIdentifier = "FeedCell"

class FeedsListController: UIViewController {
    
    //MARK: - Properties
    
    private let tableView = UITableView()
    private var feeds = [Feed]()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - API
    
    func fetchFeeds() {
        Service.shared.fetchFeeds { (feeds) in
            switch feeds {
            case .failure(let err):
                print("DEBUG: Error fetching news: \(err)")
            case .success(let feeds):
                print("DEBUG: Fetched news: \(feeds)")
                self.feeds = feeds
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    func configure() {
        configureUI()
        fetchFeeds()
    }
    
    func configureUI() {
        view.backgroundColor = .red
        
        configureTableView()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FeedCell.self, forCellReuseIdentifier: reuseIdentifier)
//        tableView.estimatedRowHeight = 1
//        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FeedsListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        
        cell.feed = feeds[indexPath.row]
        
        return cell
    }
    
    
}
