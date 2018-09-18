//
//  FirebaseChat.swift
//  Firebase Chat
//
//  Created by Lisa Sampson on 9/18/18.
//  Copyright © 2018 Lisa Sampson. All rights reserved.
//

import Foundation
import MessageKit

struct ChatRoom: Equatable {
    let chatRoom: String
    let id: UUID
    var messages: [ChatRoom.Message]
    
    init(chatRoom: [String: Any]) {
        self.chatRoom = chatRoom["chatRoom"] as! String
        self.id = chatRoom["id"] as! UUID
        self.messages = chatRoom["messages"] as! [ChatRoom.Message]
    }
    
    init( chatRoom: String, id: UUID = UUID(), messages: [ChatRoom.Message] = []) {
        self.chatRoom = chatRoom
        self.id = id
        self.messages = messages
    }
    
    struct Message: Equatable {
        let username: String
        let timestamp: Date
        let messageId: UUID
        let text: String
        
        init(message: [String: Any]) {
            self.username = message["username"] as! String
            self.messageId = message["messageId"] as! UUID
            self.timestamp = message["timestamp"] as! Date
            self.text = message["text"] as! String
        }
        
        init(username: String, timestamp: Date = Date(), messageId: UUID = UUID(), text: String) {
            self.username = username
            self.timestamp = timestamp
            self.messageId = messageId
            self.text = text
        }
    }
}


