//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Gi Pyo Kim on 11/12/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation
import MessageKit

class ChatRoom: Codable, Equatable {
    
    let title: String
    var messages: [ChatRoom.Message]
    let identifier: String
    
    init(title: String, messages: [ChatRoom.Message] = [], identifier: String = UUID().uuidString) {
        self.title = title
        self.messages = messages
        self.identifier = identifier
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case messages
        case identifier
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: .title)
        if let messages = try container.decodeIfPresent([String: Message].self, forKey: .messages) {
            self.messages = Array(messages.values)
        } else {
            self.messages = []
        }
        let identifier = try container.decode(String.self, forKey: .identifier)
        
        self.title = title
        self.identifier = identifier
    }
    
    static func == (lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier &&
            lhs.messages == rhs.messages
    }
    
    struct Message: Codable, Equatable, MessageType {

        let text: String
        let senderId: String
        let displayName: String
        var messageId: String
        var sentDate: Date
        var sender: SenderType {
            return Sender(senderId: senderId, displayName: displayName)
        }
        var kind: MessageKind { return .text(text)}
        
        init(text: String, sender: Sender, messageId: String = UUID().uuidString, sentDate: Date = Date()) {
            self.text = text
            self.senderId = sender.senderId
            self.displayName = sender.displayName
            self.messageId = messageId
            self.sentDate = sentDate
        }
        
        
        enum CodingKeys: String, CodingKey {
            case text
            case senderId
            case displayName
            case messageId
            case sentDate
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let text = try container.decode(String.self, forKey: .text)
            let senderId = try container.decode(String.self, forKey: .senderId)
            let displayName = try container.decode(String.self, forKey: .displayName)
            let messageId = try container.decode(String.self, forKey: .messageId)
            let sentDate = try container.decode(Date.self, forKey: .sentDate)
            
            let sender = Sender(senderId: senderId, displayName: displayName)
            
            self.init(text: text, sender: sender, messageId: messageId, sentDate: sentDate)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(text, forKey: .text)
            try container.encode(senderId, forKey: .senderId)
            try container.encode(displayName, forKey: .displayName)
            try container.encode(messageId, forKey: .messageId)
            try container.encode(sentDate, forKey: .sentDate)
            
        }
        
    }
    
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

