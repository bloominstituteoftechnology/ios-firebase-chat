//
//  User.swift
//  FirebaseChat
//
//  Created by Shawn Gee on 4/21/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation
import MessageKit

struct User: SenderType {
    let id: String
    let displayName: String
    
    var senderId: String {
        return id
    }
}

// MARK: - Dictionary Coding

extension User {
    
    enum Keys {
        static let senderId = "senderId"
        static let displayName = "displayName"
    }
    
    init?(with dictionary: [String: String]) {
        guard
            let id = dictionary[Keys.senderId],
            let displayName = dictionary[Keys.displayName] else { return nil }
        
        self.id = id
        self.displayName = displayName
    }
}

extension SenderType {
    var dictionaryRepresentation: [String: String] {
        return [User.Keys.senderId: senderId, User.Keys.displayName: displayName]
    }
}
