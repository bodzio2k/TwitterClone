//
//  EditProfileViewModel.swift
//  TwitterClone
//
//  Created by Krzysztof Podolak on 16/08/2020.
//  Copyright © 2020 Krzysztof Podolak. All rights reserved.
//

import Foundation

enum EditProfileField: Int, CaseIterable {
    case username
    case fullName
    case bio
    
    var description: String {
        switch self {
        case .username:
            return "Username"
        case .fullName:
            return "Name"
        case .bio:
            return "Bio"
        }
    }
}

struct EditProfileViewModel {
    let user: User
    let field: EditProfileField
    
    var titleLabelText: String {
        return field.description
    }
    
    var textFieldText: String {
        switch self.field {
        case .username:
            return user.username
        case .fullName:
            return user.fullname
        case .bio:
            return ""
        }
    }
    
    var bioPlaceHolderLabelShouldHide: Bool {
        if field != .bio {
            return true
        }
        
        if field == .bio && (user.bio ?? "").count > 0 {
            return true
        }
        
        return false
    }
    
    var bioTextViewShouldHide: Bool {
        return field != .bio// || field == .bio && (user.bio ?? "").count == 0
    }
    
    var textFieldShouldHide: Bool {
        return field == .bio
    }
    
    var bioText: String {
        return user.bio ?? ""
    }
    
    var placeholderText: String {
        return field.description + " (mandatory)"
    }
}
