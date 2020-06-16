//
//  ChatRoom.swift
//  iosFireBaseChat
//
//  Created by Kelson Hartle on 6/15/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation
import MessageKit

class ChatRoom: Codable, Equatable {
    
    let title: String
    var messages: [ChatRoom.Message]
    var identifier: String
    
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
    
    struct Message: Codable, Equatable {
        let text: String
        let timestamp: Date
        let displayName: String
        
        init(text: String, displayName: String, timestamp: Date = Date()) {
            self.text = text
            self.displayName = displayName
            self.timestamp = timestamp
            
        }
        
        struct Sender : SenderType {
            
            let messageSenderName: String
            init(messageSenderName: String) {
                self.messageSenderName = messageSenderName
            }
            
            var senderId: String {
                return displayName
            }
            var displayName: String {
                return messageSenderName
            }
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
        return Sender(messageSenderName: displayName)
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
