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
    
    var tableView = UITableView()
    var feeds = [Feed]()
    
    private let newsRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - API
    
    func fetchFeeds() {
        APIService.shared.fetchFeeds { (feeds) in
            switch feeds {
            case .failure(let err):
                self.showErrorAlert(message: "Error fetching news \(err.localizedDescription)")
            case .success(let feeds):
                self.feeds = feeds
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case nil:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.showErrorAlert(message: "Turn on the Internet to update the news.")
            }
        }
    }
    
    // MARK: - Helper Functions
    
    func configure() {
        configureUI()
//        fetchFeeds()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureTableView()
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "News"
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(goToSavedFeedsTapped))
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FeedCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.refreshControl = newsRefreshControl
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func showErrorAlert(message: String) {
        let alert = AlertGenerate.alert(title: "Error ⚠️", message: message, controller: self, buttons: nil, completion: nil)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Selectors

    @objc private func refresh(sender: UIRefreshControl) {
        fetchFeeds()
        sender.endRefreshing()
    }
    
    @objc private func goToSavedFeedsTapped() {
        navigationController?.pushViewController(SavedFeedsController(), animated: true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FeedWebViewController()
        vc.feeds = feeds
        vc.currentIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Favorite") { (action, view, completionHandler) in
            DBService.shared.saveCurrentFeed(item: self.feeds[indexPath.row])
            completionHandler(true)
        }
        action.image = UIImage(systemName: "star.fill")
        action.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
