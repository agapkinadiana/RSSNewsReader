//
//  SplashController.swift
//  RSSNewsReader
//
//  Created by Diana Agapkina on 29.11.20.
//

import UIKit

class SplashController: UIViewController {
    
    // MARK: - Properties
    
    //private var feeds: [Feed]? = nil
    var timer: Timer?
    private var feeds = [Feed]()
    
    var timerValue: CGFloat = 15.0
    lazy var count = self.timerValue
    
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
                print("DEBUG: Success")
                self.feeds = feeds
            case nil:
                self.feeds = []
                self.showErrorAlert(message: "Turn on the Internet to update the news.")
            }
        }
    }
    
    // MARK: - Helper Functions
    
    func configure() {
        view.backgroundColor = .systemBackground
        setupObservers()
        setupTimer()
//        fetchFeeds()
//        navigateToFeedsList()
    }
    
    func navigateToFeedsList() {
        let vc = FeedsListController()
        vc.feeds = feeds
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func showErrorAlert(message: String) {
        let alert = AlertGenerate.alert(title: "Error ⚠️", message: message, controller: self, buttons: nil, completion: nil)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Selectors
    
    @objc func handleTimer() {
        print("DEBUG: \(count)")
        if count <= 0 {
            print("DEBUG: end \(count)")
            fetchFeeds()
            resetTimer()
        } else {
            count -= 1.0
        }
    }
}

// MARK: - Timer Control

extension SplashController {
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
    }
    
    func resetTimer() {
        timer?.invalidate()
        count = timerValue
        setupTimer()
    }
    
    @objc func pauseWhenBackground(noti: Notification) {
        guard let timer = self.timer else { return }
        timer.invalidate()
        let shared = UserDefaults.standard
        shared.set(Date(), forKey: "savedTime")
    }
    
    @objc func willEnterForeground(noti: Notification) {
        if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
            let components = self.getTimeDifference(startDate: savedDate)
            guard let minutes = components.minute else { return }
            guard let seconds = components.second else { return }
            
            let differenceCount = minutes * 60 + seconds
            self.count -= CGFloat(differenceCount)
            
            setupTimer()
        }
    }
    
    func getTimeDifference(startDate: Date) -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.minute, .second], from: startDate, to: Date())
    }
}
