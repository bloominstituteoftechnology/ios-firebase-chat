//
//  ChatRoom.swift
//  Firebase Chat
//
//  Created by Wyatt Harrell on 4/21/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import Foundation
import MessageKit

class ChatRoom: Codable {
    
    let title: String
    let identifier: String
    var messages: [ChatRoom.Message]
    
    
    init(title: String, messages: [ChatRoom.Message] = [], identifier: String = UUID().uuidString) {
        self.title = title
        self.messages = messages
        self.identifier = identifier
    }
    
    struct Message: Codable, MessageType {
        
        let text: String
        let displayName: String
        let timestamp: Date
        let senderID: String
        
        var messageId: String
        
        var sentDate: Date {
            return timestamp
        }
        var kind: MessageKind {
            return .text(text)
        }
        var sender: SenderType {
            return Sender(senderId: senderID, displayName: displayName)
        }
        
        init(text: String, sender: Sender, timestamp: Date = Date(), messageID: String = UUID().uuidString) {
            self.text = text
            self.displayName = sender.displayName
            self.senderID = sender.senderId
            self.timestamp = timestamp
            self.messageId = messageID
        }
    }
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

