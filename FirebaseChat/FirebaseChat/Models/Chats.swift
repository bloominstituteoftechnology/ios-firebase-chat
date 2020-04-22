//
//  Chats.swift
//  FirebaseChat
//
//  Created by Bradley Diroff on 4/21/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import Foundation
import MessageKit

class Chats: Codable, Equatable {
    
    let title: String
    var messages: [Chats.Message]
    let identifier: String
    
    init(title: String, messages: [Chats.Message] = [], identifier: String = UUID().uuidString) {
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
    
    struct Message: Codable, Equatable {
        
        let text: String
        let timestamp: Date
        let displayName: String
        
        enum CodingKeys: String, CodingKey {
            case displayName
            case senderID
            case text
            case timestamp
            case messageID
        }
        
        init(text: String, timestamp: Date = Date(), displayName: String) {
            self.text = text
            self.displayName = displayName
            self.timestamp = timestamp
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let text = try container.decode(String.self, forKey: .text)
            let displayName = try container.decode(String.self, forKey: .displayName)
            let timestamp = try container.decode(Date.self, forKey: .timestamp)
            
            self.init(text: text, timestamp: timestamp, displayName: displayName)
            
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(displayName, forKey: .displayName)
            try container.encode(timestamp, forKey: .timestamp)
            try container.encode(text, forKey: .text)
        }
    }
    
    static func ==(lhs: Chats, rhs: Chats) -> Bool {
        return lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier &&
            lhs.messages == rhs.messages
    }
}
