//
//  Messages.swift
//  FirebaseChat
//
//  Created by Christopher Aronson on 6/18/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation

struct Message: Codable {
    let sender: User
    let timestamp: Date
    let message: String
    
    init?(data: [String: Any]) {
        guard let sender = data["sender"] as? User,
        let timestamp = data["timestamp"] as? Date,
        let message = data["message"] as? String
        else { return nil }
        
        self.sender = sender
        self.timestamp = timestamp
        self.message = message
    }
}
