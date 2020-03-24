//
//  Message.swift
//  Chat
//
//  Created by Nick Nguyen on 3/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation
import MessageKit

class MessageThread: Codable, Equatable {
    
    let title: String
    var messages: [MessageThread.Message]
    let identifier: String
    
    init(title: String, messages: [MessageThread.Message] = [], identifier: String = UUID().uuidString) {
        self.title = title
        self.messages = messages
        self.identifier = identifier
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: .title)
        let identifier = try container.decode(String.self, forKey: .identifier)
        if let messages = try container.decodeIfPresent([String: Message].self, forKey: .messages) {
            self.messages = Array(messages.values)
        } else {
            self.messages = []
        }
        
        self.title = title
        self.identifier = identifier
    }
    
    
    struct Message: Codable, Equatable , MessageType {
    
        // v1
        let text: String
        let timestamp: Date
        let displayName: String
        
        // v2
        var senderId: String
        var sender: SenderType {
            return Sender(senderId: senderId, displayName: displayName)
        }
        
        var messageId: String
        var sentDate: Date {
            return timestamp
        }
        var kind: MessageKind {
            return .text(text)
        }
        
        init(text: String,
             sender: Sender,
             timestamp: Date = Date(),
             messageId: String = UUID().uuidString ) {
            
            self.text = text
            self.displayName = sender.displayName
            self.timestamp = timestamp
            self.messageId = messageId
            self.senderId = sender.senderId
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let text = try container.decode(String.self, forKey: .text)
            let displayName = try container.decode(String.self, forKey: .displayName)
            let timestamp = try container.decode(Date.self, forKey: .timestamp)
            
            var senderId: String = UUID().uuidString
            if let decodedSenderId = try? container.decode(String.self, forKey: .senderId) {
                senderId = decodedSenderId
            }
            let sender = Sender(senderId: senderId, displayName: displayName)
            
            self.init(text:text,sender: sender,timestamp:timestamp)
            
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(displayName, forKey: .displayName)
            try container.encode(senderId, forKey: .senderId)
            try container.encode(timestamp, forKey: .timestamp)
            try container.encode(text, forKey: .text)
        }
         
        enum CodingKeys: String , CodingKey {
            case displayName
            case senderId
            case text
            case timestamp
        }
    
    }
    
    static func ==(lhs: MessageThread, rhs: MessageThread) -> Bool {
        return lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier &&
            lhs.messages == rhs.messages
    }
}
struct Sender: SenderType {
    var senderId: String
    
    var displayName: String
    
    
}
