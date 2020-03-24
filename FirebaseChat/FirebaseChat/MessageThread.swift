//
//  MessageThread.swift
//  FirebaseChat
//
//  Created by Ufuk Türközü on 24.03.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import MessageKit

class MessageThread: Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case messages
        case identifier
    }
    
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
    
    struct Sender: SenderType {
        var displayName: String
        var senderId: String
        var username: String
    }
    
    struct Message: Codable, Equatable, MessageType {
        
        enum MessageKeys: String, CodingKey {
            case message
            case username
            case sentDate
            case senderID
        }
        
        var username: String
        var message: String
        var sentDate: Date
        var senderId: String
        var messageId: String
        
        var sender: SenderType {
            return Sender(displayName: username, senderId: senderId, username: username)
        }
        var kind: MessageKind {
            return .text(message)
        }
        
        init(message: String, sender: Sender, messageId: String = UUID().uuidString, sentDate: Date = Date()) {
            self.message = message
            self.username = sender.username
            self.sentDate = sentDate
            self.messageId = messageId
            self.senderId = sender.senderId
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: MessageKeys.self)
            
            let message = try container.decode(String.self, forKey: .message)
            let username = try container.decode(String.self, forKey: .username)
            let sentDate = try container.decode(Date.self, forKey: .sentDate)
            
            var senderId: String = UUID().uuidString
            if let decodedSenderId = try? container.decode(String.self, forKey: .senderID) {
                senderId = decodedSenderId
            }
            
            let sender = Sender(displayName: username, senderId: senderId, username: username)
            
            self.init(message: message, sender: sender, sentDate: sentDate)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: MessageKeys.self)
            
            try container.encode(username, forKey: .username)
            try container.encode(senderId, forKey: .senderID)
            try container.encode(sentDate, forKey: .sentDate)
            try container.encode(message, forKey: .message)

        }
    }
    
    static func == (lhs: MessageThread, rhs: MessageThread) -> Bool {
        return lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier &&
            lhs.messages == rhs.messages
    }
}
