//
//  MessageThread.swift
//  FireBaseChat
//
//  Created by Rachael Cedeno on 4/27/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
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
    
    
    struct Message: Codable, Equatable {
        
        let text: String
        let timestamp: Date
        let displayName: String
        
        init(text: String, displayName: String, timestamp: Date = Date()) {
            self.text = text
            self.displayName = displayName
            self.timestamp = timestamp
            
        }
    }
    
    static func ==(lhs: MessageThread, rhs: MessageThread) -> Bool {
        return lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier &&
            lhs.messages == rhs.messages
    }
}

extension MessageThread.Message: MessageType {
    
    var sender: SenderType {
        return Sender(senderId: "", displayName: "")
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
