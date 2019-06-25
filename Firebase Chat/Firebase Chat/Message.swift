//
//  Message.swift
//  Firebase Chat
//
//  Created by Mitchell Budge on 6/25/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import Foundation
import MessageKit

class Message: Codable, Equatable, MessageType {
    
    let text: String
    let timestamp: Date
    let displayName: String
    let senderId: String
    var messageId: String
    var sender: SenderType {
        return Sender(displayName: displayName, senderId: senderId)
    }
    var sentDate: Date {
        return timestamp
    }
    var kind: MessageKind {
        return MessageKind.text(text)
    }
    
    init(text: String, sender: Sender, timestamp: Date = Date(), messageId: String = UUID().uuidString) {
        self.text = text
        self.displayName = sender.displayName
        self.senderId = sender.senderId
        self.messageId = messageId
        self.timestamp = timestamp
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.text == rhs.text &&
        lhs.displayName == rhs.displayName &&
        lhs.senderId == rhs.senderId &&
        lhs.messageId == rhs.messageId &&
        lhs.timestamp == rhs.timestamp
    }
}
