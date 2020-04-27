//
//  MessageRepresentation.swift
//  Firebase Chat
//
//  Created by David Wright on 4/26/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation

struct MessageRepresentation: Codable, Equatable {
    
    let text: String
    let displayName: String
    let timestamp: Date
    let senderID: String
    let messageID: String
        
    init(text: String, sender: Sender = K.testUser, timestamp: Date = Date(), messageID: String = UUID().uuidString) {
        self.text = text
        self.displayName = sender.displayName
        self.timestamp = timestamp
        self.senderID = sender.senderId
        self.messageID = messageID
    }
}
