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
    
    init?(with dictionary: [String: String]) {
        guard
            let id = dictionary["senderId"],
            let displayName = dictionary["displayName"] else { return nil }
        
        self.id = id
        self.displayName = displayName
    }
}

extension SenderType {
    var dictionaryRepresentation: [String: String] {
        return ["senderId": senderId, "displayName": displayName]
    }
}
