//
//  MainTabBarController.swift
//  RSSNewsReader
//
//  Created by Diana Agapkina on 26.11.20.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    //MARK: - Properties
    
    private let newsListController = NewsListController()
    private let savedNewsController = SavedNewsController()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        viewControllers = [
            configureNavigationController(viewController: newsListController, tabBarSystemItem: .recents, tag: 0),
            configureNavigationController(viewController: savedNewsController, tabBarSystemItem: .featured, tag: 1)
        ]
    }
    
    func configureNavigationController(viewController: UIViewController, tabBarSystemItem: UITabBarItem.SystemItem, tag: Int) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(tabBarSystemItem: tabBarSystemItem, tag: tag)
        return navController
    }
}

