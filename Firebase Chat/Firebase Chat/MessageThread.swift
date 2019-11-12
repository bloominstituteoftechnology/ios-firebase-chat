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
    var messages: [Message] = []
    
    init(title: String, messages: [Message] = [], identifier: String = UUID().uuidString) {
        self.title = title
        self.identifier = identifier
        self.messages = messages
    }
    
    init?(from dictionary: NSDictionary) {
        guard let title = dictionary["title"] as? String,
            let identifier = dictionary["identifier"] as? String else { return nil }
        
        self.title = title
        self.identifier = identifier
        
        if let messages = dictionary["messages"] as? [NSDictionary] {
            for message in messages {
                guard let createdMessage = Message(from: message) else { continue }
                self.messages.append(createdMessage)
            }
        }
    }
    
    var dictionaryRepresentation: NSDictionary {
        let messages = self.messages.map({ $0.dictionaryRepresentation })
        return [
            "title": title,
            "identifier": identifier,
            "messages": messages
        ]
    }
    
    struct Message: MessageType {
        var sender: SenderType
        var messageId: String
        var sentDate: Date
        var text: String
        
        var kind: MessageKind {
            return .text(text)
        }
        
        var dictionaryRepresentation: NSDictionary {
            guard let sender = sender as? Sender else { return [:] }
            let formattedDate = DateFormatter().string(from: sentDate)
            return [
                "messageId": messageId,
                "sentDate": formattedDate,
                "text": text,
                "sender": sender.dictionaryRepresentation
            ]
        }
        
        init(text: String, sender: Sender, timestamp: Date = Date(), messageId: String = UUID().uuidString) {
            self.text = text
            self.sender = sender
            self.sentDate = timestamp
            self.messageId = messageId
        }
        
        init?(from dictionary: NSDictionary) {
            guard let messageId = dictionary["messageId"] as? String,
                let text = dictionary["text"] as? String,
                let senderDictionary = dictionary["sender"] as? [String: String],
                let sender = Sender(from: senderDictionary),
                let dateText = dictionary["sentDate"] as? String,
                let date = DateFormatter().date(from: dateText) else { return nil }
            
            self.messageId = messageId
            self.text = text
            self.sender = sender
            self.sentDate = date
        }
    }
}
