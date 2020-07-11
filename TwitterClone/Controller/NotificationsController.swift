//
//  NotificationsController.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 12/03/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

class NotificationsController: RootViewController {
    var notifications = Array<Notification>()
    var tableView: UITableView = {
        let tv = UITableView()
        
        return tv
    }()
    let reuseIdentifier = "NotificationViewCell"
    var user: User?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        navigationItemTitle = "Notifications"
        
        super.viewDidLoad()
        
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    //MARK: Helpers
    override func configureUI() {
        view.addSubview(tableView)
        tableView.addConstraintsToFillView(self.view)
        
        tableView.register(NotificationViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 60.0
        tableView.separatorStyle = .none
    }
    
    //MARK: API
    func fetchNotifications() -> Void {
        NotificationService.shared.fetchNotifications() { (notifications) in
            self.notifications = notifications
            self.tableView.reloadData()
        }
    }
}

extension NotificationsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NotificationViewCell else {
            fatalError()
        }
        
        let notification = notifications[indexPath.row]
        cell.configure(for: notification)
        cell.delegate = self
        
        return cell
    }
}

extension NotificationsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tweetId = notifications[indexPath.row].tweet?.tweetId else {
            return
        }
        
        TweetService.shared.fetchTweet(with: tweetId) { (tweet) in
            let tweetController = TweetController(tweet: tweet)
            
            self.navigationController?.pushViewController(tweetController, animated: true)
        }
    }
}

extension NotificationsController: NotificationViewCellDelegate {
    func profiePhotoImageViewTapped(at cell: NotificationViewCell) {
        guard let user = cell.notification?.user else {
            return
        }
        
        let profileController = ProfileController(user: user)
        navigationController?.pushViewController(profileController, animated: true)
    }
}
