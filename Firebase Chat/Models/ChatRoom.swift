//
//  ChatRoom.swift
//  Firebase Chat
//
//  Created by Wyatt Harrell on 4/21/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import Foundation
import MessageKit

class ChatRoom: Codable, Equatable {
    
    let title: String
    let identifier: String
    var messages: [ChatRoom.Message]
    
    init(title: String, messages: [ChatRoom.Message] = [], identifier: String = UUID().uuidString) {
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
    
    struct Message: Codable, Equatable, MessageType {
        
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
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            // VI
            let text = try container.decode(String.self, forKey: .text)
            let displayName = try container.decode(String.self, forKey: .displayName)
            let timestamp = try container.decode(Date.self, forKey: .timestamp)
            // V2
            let senderID = (try? container.decode(String.self, forKey: .senderID)) ?? UUID().uuidString
            let messageID = (try? container.decode(String.self, forKey: .messageId)) ?? UUID().uuidString
            let sender = Sender(senderId: senderID, displayName: displayName)
            self.init(text: text, sender: sender, timestamp: timestamp, messageID: messageID)
        }
    }
    static func ==(lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier &&
            lhs.messages == rhs.messages
    }
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

