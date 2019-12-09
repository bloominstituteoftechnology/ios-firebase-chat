//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Bobby Keffury on 12/6/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import Foundation
import MessageKit

class ChatRoom: Codable {
    
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

    class Message: Codable, Equatable {
        // v1
        let text: String
        let timestamp: Date
        let displayName: String
        // v2
        let senderID: String
        
        
        init(text: String, displayName: String, senderID: String = UUID().uuidString, timestamp: Date = Date()) {
            self.text = text
            self.displayName = displayName
            self.timestamp = timestamp
            self.senderID = senderID
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.text = try container.decode(String.self, forKey: .text)
            self.displayName = try container.decode(String.self, forKey: .displayName)
            self.timestamp = try container.decode(Date.self, forKey: .timestamp)
            if let senderID = try? container.decode(String.self, forKey: .senderID) {
                self.senderID = senderID
            } else {
                // This may be a v1 message.
                self.senderID = UUID().uuidString
            }
        }
        static func ==(lhs: Message, rhs: Message) -> Bool {
            return lhs.text == rhs.text &&
                lhs.displayName == rhs.displayName &&
                lhs.timestamp == rhs.timestamp &&
                lhs.displayName == rhs.senderID
        }
    }
    static func ==(lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier &&
            lhs.messages == rhs.messages
    }
}

extension ChatRoom.Message : MessageType {
    var sender: SenderType {
        return Sender(senderId: senderID, displayName: displayName)
    }
    
    var messageId: String {
        return UUID().uuidString
    }
    
    var sentDate: Date {
        return timestamp
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}
