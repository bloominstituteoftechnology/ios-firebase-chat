//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Shawn Gee on 4/21/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

struct ChatRoom {
    let name: String
    let id: String
}

// MARK: - Dictionary Coding

extension ChatRoom {
    
    enum Keys {
        static let name = "name"
        static let id = "id"
    }
    
    init?(with dictionary: [String: String]) {
        guard
            let name = dictionary[Keys.name],
            let id = dictionary[Keys.id] else { return nil }
        
        self.name = name
        self.id = id
    }
}
