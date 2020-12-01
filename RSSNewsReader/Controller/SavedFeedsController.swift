//
//  SavedFeedsController.swift
//  RSSNewsReader
//
//  Created by Diana Agapkina on 29.11.20.
//

import UIKit
import SnapKit

private let reuseIdentifier = "FeedCell"

class SavedFeedsController: UIViewController {
    
    //MARK: - Properties
    
    private let tableView = UITableView()
    private var feeds = [Feed]()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - DB Functions
    
    func fetchFeeds() {
        feeds = DBService.shared.fetchSavedFeed()
    }
    
    // MARK: - Helper Functions
    
    func configure() {
        configureUI()
        fetchFeeds()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureTableView()
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "Favorites news"
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FeedCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func deleteFeed(at indexPath: IndexPath, in tableView: UITableView) {
        DBService.shared.deleteSelectedFeed(feedId: self.feeds[indexPath.row].id)
        self.feeds.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SavedFeedsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.feed = feeds[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: load cached page to WebView
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Unfavorite") { (action, view, completionHandler) in
            self.deleteFeed(at: indexPath, in: tableView)
            completionHandler(true)
        }
        action.image = UIImage(systemName: "star.fill")
        action.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
