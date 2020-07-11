//
//  NotificationViewModel.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 11/07/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import UIKit

struct NotificationViewModel {
    private let dateFormatter = DateFormatter()
    private let componentsFormatter = DateComponentsFormatter()
    private let notification: Notification
    private let notificationType: NotificationType
    private var notificationMessage: String {
        switch notificationType {
        case .follow:
            return " started following You."
        case .like:
            return " liked your tweet."
        case .retweet:
            return " retweeted Your tweet."
        case .reply:
            return " replied to Your tweet."
        case .mention:
            return " mentioned You."
        }
    }
    private let now = Date()
    var profilePhotoUrl: URL? {
        return notification.user.profilePhotoURL
    }
    
    init(_ notification: Notification) {
        self.notification = notification
        self.notificationType = notification.type
    }
    
    var notificationText: NSAttributedString {
        let userText = NSAttributedString(string: notification.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)])
        let messageText = NSAttributedString(string: notificationMessage, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)])
        let timestampText = NSAttributedString(string: " • \(componentsFormatter.string(from: notification.timestamp, to: now)!)", attributes: [.font: UIFont.systemFont(ofSize: 12.0), .foregroundColor: UIColor.lightGray])
        let notificationText = NSMutableAttributedString()
        
        notificationText.append(userText)
        notificationText.append(messageText)
        notificationText.append(timestampText)
        
        return notificationText
    }
}
