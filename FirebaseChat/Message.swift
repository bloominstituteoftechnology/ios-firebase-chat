//
//  Message.swift
//  FirebaseChat
//
//  Created by Kenneth Jones on 10/2/20.
//

import Foundation
import MessageKit

struct Message: Codable, Equatable, MessageType {
    enum CodingKeys: String, CodingKey {
        case displayName
        case senderId
        case text
        case timestamp
    }
    
    // MARK: - Message Type
    var sender: SenderType {
        return Sender(senderId: senderId, displayName: displayName)
    }
    var messageId: String
    var sentDate: Date {
        return timestamp
    }
    var kind: MessageKind {
        return .text(text)
    }
    
    let text: String
    let timestamp: Date
    let displayName: String
    let senderId: String
    
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
        
        var senderId = try? container.decode(String.self, forKey: .senderId)
        
        if senderId == nil {
            senderId = UUID().uuidString
        }
        
        let sender = Sender(senderId: senderId!, displayName: displayName)
        
        self.init(text: text, sender: sender, timestamp: timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(displayName, forKey: .displayName)
        try container.encode(senderId, forKey: .senderId)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(text, forKey: .text)
    }
}
