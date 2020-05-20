//
//  MessageThread.swift
//  Chat
//
//  Created by Chris Dobek on 5/20/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import MessageKit

struct ChatRoom: Codable, Equatable {
    
    let title: String
    var messages: [ChatRoom.Message]
    let identifier: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case messages
        case identifier
        
    }
    
    init(title: String, messages: [Message] = [], identifier: String = UUID().uuidString) {
        self.title = title
        self.messages = messages
        self.identifier = identifier
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: .title)
        let identifier = try container.decode(String.self, forKey: .identifier)
        if let messages = try container.decodeIfPresent([String : Message].self, forKey: .messages) {
            self.messages = Array(messages.values)
        } else {
            self.messages = []
        }
        
        self.title = title
        self.identifier = identifier
    }
    
    struct Message: Codable, Equatable, MessageType {
        let message: String
        let username: String
        let sentDate: Date
        let senderID: String
        let messageId: String
        
        var sender: SenderType {
            return Sender(senderId: senderID, displayName: username)
        }
        
        var kind: MessageKind {
            return .text(message)
        }
        
        init(message: String, sender: Sender, sentDate: Date = Date(), messageID: String = UUID().uuidString) {
            self.message = message
            self.senderID = sender.senderId
            self.username = sender.displayName
            self.sentDate = sentDate
            self.messageId = messageID
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: MessageKeys.self)
            
            let message = try container.decode(String.self, forKey: .message)
            let username = try container.decode(String.self, forKey: .username)
            let sentDate = try container.decode(Date.self, forKey: .sentDate)
            var senderID = try? container.decode(String.self, forKey: .senderID)
            if senderID == nil {
                senderID = UUID().uuidString
            }
            let sender = Sender(senderId: (senderID!), displayName: username)
            
            self.init(message: message, sender: sender, sentDate: sentDate)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: MessageKeys.self)
            try container.encode(username, forKey: .username)
            try container.encode(senderID, forKey: .senderID)
            try container.encode(sentDate, forKey: .sentDate)
            try container.encode(message, forKey: .message)
        }
        
        enum MessageKeys: String, CodingKey {
            case message
            case username
            case sentDate
            case senderID
        }
    }
}
static func == (lhs: ChatRoom, rhs: ChatRoom) -> Bool {
    return lhs.title == rhs.title &&
        lhs.identifier == rhs.identifier &&
        lhs.messages == rhs.messages
}
struct Sender: SenderType {
    var senderId: String
    var displayName: String
}
}
