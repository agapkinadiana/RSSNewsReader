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
        Service.shared.fetchFeeds { (feeds) in
            switch feeds {
            case .failure(let err):
                print("DEBUG: Error fetching news: \(err)")
            case .success(let feeds):
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
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureTableView()
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "News"
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FeedCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.refreshControl = newsRefreshControl
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Selectors

    @objc private func refresh(sender: UIRefreshControl) {
        fetchFeeds()
        sender.endRefreshing()
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
        cell.delegate = self
        cell.saveFeedButton.isSelected = feeds[indexPath.row].isSaved
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FeedWebViewController()
        vc.urlString = feeds[indexPath.row].link
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - FeedCellDelegate

extension FeedsListController: FeedCellDelegate {
    func addFeedToFeatured(cell: FeedCell) {
        cell.saveFeedButton.isSelected = !cell.saveFeedButton.isSelected
        
        guard let indexPath = tableView.indexPath(for: cell) else  { return }
        feeds[indexPath.row].isSaved = !feeds[indexPath.row].isSaved
        
        // TODO: Save to core data if not saved
        
        // TODO: Remove from db if saved
    }
}
