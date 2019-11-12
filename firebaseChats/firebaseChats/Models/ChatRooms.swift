//
//  ChatRooms.swift
//  firebaseChats
//
//  Created by Jesse Ruiz on 11/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import MessageKit

class ChatRoom: Codable, Equatable {
    
    let title: String
    var messages: [ChatRoom.Message]
    let identifier: String
    
    init(title: String,
         messages: [ChatRoom.Message] = [],
         identifier: String = UUID().uuidString) {
        
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
    
    static func ==(lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier &&
            lhs.messages == rhs.messages
    }
    
    struct Message: Codable, Equatable, MessageType {
        
        var sender: SenderType { return Sender(senderId: senderId, displayName: displayName) }
        
        var sentDate: Date { return timestamp }
        
        var kind: MessageKind { return .text(text) }
        
        
        let text: String
        let timestamp: Date
        let displayName: String
        let senderId: String
        var messageId: String
        
        init(text: String, sender: Sender, timestamp: Date = Date(), messageId: String = UUID().uuidString) {
            self.text = text
            self.displayName = sender.displayName
            self.senderId = sender.senderId
            self.timestamp = timestamp
            self.messageId = messageId
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let text = try container.decode(String.self, forKey: .text)
            let displayName = try container.decode(String.self, forKey: .displayName)
            let timestamp = try container.decode(Date.self, forKey: .timestamp)
            
            let senderId: String
            if let id = try? container.decode(String.self, forKey: .senderId) {
                senderId = id
            } else {
                senderId = UUID().uuidString
            }
            
            
            let sender = Sender(senderId: senderId, displayName: displayName)
            self.init(text: text, sender: sender, timestamp: timestamp)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(displayName, forKey: .displayName)
            try container.encode(senderId, forKey: .senderId)
            try container.encode(timestamp, forKey: .timestamp)
            try container.encode(text, forKey: .text)
        }
        
        enum CodingKeys: String, CodingKey {
            case displayName
            case senderId
            case text
            case timestamp
        }
    }
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

extension Sender {
    
    var dictionaryRepresentation: [String : String] {
        return ["id" : senderId,
                "displayName" : displayName]
    }
    
    init?(dictionary: [String : String]) {
        guard let id = dictionary["id"],
            let displayName = dictionary["displayName"] else { return nil }
        self.init(senderId: id, displayName: displayName)
    }
}





