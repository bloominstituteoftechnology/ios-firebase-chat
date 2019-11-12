//
//  MessageThread.swift
//  Firebase Chat
//
//  Created by Isaac Lyons on 11/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import MessageKit
import Firebase

class MessageThread {
    let title: String
    let identifier: String
    var messages: [Message]
    
    init(title: String, messages: [Message] = [], identifier: String = UUID().uuidString) {
        self.title = title
        self.identifier = identifier
        self.messages = messages
    }
    
    var dictionaryRepresentation: [String: String] {
        return [
            "title": title,
            "identifier": identifier
        ]
    }
    
//    var messagesDictionaryRepresentation: [[String: String]] {
//        
//    }
    
    struct Message: MessageType {
        var sender: SenderType
        var messageId: String
        var sentDate: Date
        var kind: MessageKind
        
        init(text: String, sender: Sender, timestamp: Date = Date(), messageId: String = UUID().uuidString) {
            self.kind = .text(text)
            self.sender = sender
            self.sentDate = timestamp
            self.messageId = messageId
        }
    }
}
