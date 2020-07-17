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
        super.configureUI()
        
        view.addSubview(tableView)
        tableView.addConstraintsToFillView(self.view)
        
        tableView.register(NotificationViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 60.0
        tableView.separatorStyle = .none
    }
    
    fileprivate func checkIsUserIsFollowed() {
        for (index, notification) in self.notifications.enumerated() {
            if case .follow = notification.type {
                UserService.shared.isFollowed(notification.user) { (isFollowed) in
                    self.notifications[index].user.isFollowed = isFollowed
                    let indexPath = IndexPath(item: index, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
    
    //MARK: API
    func fetchNotifications() -> Void {
        NotificationService.shared.fetchNotifications() { (notifications) in
            self.notifications = notifications.sorted { $0.timestamp > $1.timestamp }
            self.tableView.reloadData()
            
            self.checkIsUserIsFollowed()
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
        if let tweetId = notifications[indexPath.row].tweet?.tweetId {
            TweetService.shared.fetchTweet(with: tweetId) { (tweet) in
                let tweetController = TweetController(tweet: tweet)
                
                self.navigationController?.pushViewController(tweetController, animated: true)
            }
            
            return
        }
        
        let profileController = ProfileController(user: notifications[indexPath.row].user)
        
        self.navigationController?.pushViewController(profileController, animated: true)
    }
}

extension NotificationsController: NotificationViewCellDelegate {
    func followButtonTapped(at cell: NotificationViewCell) {
        guard let notification = cell.notification else {
            return
        }
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        var user = notification.user
        
        if user.isFollowed {
            UserService.shared.unfollow(user) { (err, ref) in
                user.isFollowed.toggle()
                self.notifications[indexPath.row].user = user
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        else {
            UserService.shared.follow(notification.user) { (err, ref) in
                user.isFollowed.toggle()
                self.notifications[indexPath.row].user = user
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    
    func profiePhotoImageViewTapped(at cell: NotificationViewCell) {
        guard let user = cell.notification?.user else {
            return
        }
        
        let profileController = ProfileController(user: user)
        navigationController?.pushViewController(profileController, animated: true)
    }
}
