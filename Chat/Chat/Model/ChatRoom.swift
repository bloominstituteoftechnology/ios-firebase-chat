//
//  ChatRoom.swift
//  Chat
//
//  Created by Chris Dobek on 5/20/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
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
        let timestamp: Date
        let senderID: String
        let displayName: String
        let messageId: String
        
        var sender: SenderType { Sender(senderId: senderID, displayName: displayName) }
        var sentDate: Date { timestamp }
        var kind: MessageKind { .text(text) }
        
        enum CodingKeys: String, CodingKey {
            case text
            case timestamp
            case senderID
            case displayName
            case messageID
        }
        
        init(text: String, sender: Sender, timestamp: Date = Date(), messageID: String = UUID().uuidString) {
            self.text = text
            self.senderID = sender.senderId
            self.displayName = sender.displayName
            self.timestamp = timestamp
            self.messageId = messageID
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // Version 1
            let text = try container.decode(String.self, forKey: .text)
            let displayName = try container.decode(String.self, forKey: .displayName)
            let timestamp = try container.decode(Date.self, forKey: .timestamp)
            
            // Version 2
            let senderID = (try container.decodeIfPresent(String.self, forKey: .senderID)) ?? UUID().uuidString
            let messageID = (try? container.decode(String.self, forKey: .messageID)) ?? UUID().uuidString
            
            let sender = Sender(senderId: senderID, displayName: displayName)
            
            self.init(text: text, sender: sender, timestamp: timestamp, messageID: messageID)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(text, forKey: .text)
            try container.encode(timestamp, forKey: .timestamp)
            try container.encode(senderID, forKey: .senderID)
            try container.encode(displayName, forKey: .displayName)
            try container.encode(messageId, forKey: .messageID)
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

extension Sender {
    var dictionaryRepresentation: [String : String] {
        return ["id": senderId,
                "displayName": displayName]
    }
    
    init?(dictionary: [String : String]) {
        guard let id = dictionary["id"], let displayName = dictionary["displayName"] else {
            return nil
        }
        
        self.init(senderId: id, displayName: displayName)
    }
}



