//
//  Message.swift
//  iosFirebaseChatProject
//
//  Created by BrysonSaclausa on 10/4/20.
//

import Foundation
import MessageKit

struct Message: Codable, Equatable, MessageType {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.messageId == rhs.messageId
    }
    
    enum CodingKeys: String, CodingKey {
        case displayName
        case senderId
        case text
        case timeStamp
    }
    
    // MARK: - MessageType
    var sender: SenderType {
        return Sender(senderId: senderId, displayName: displayName)
    }
    var messageId: String
    var sentDate = Date()
    var kind: MessageKind {
        return .text(text)
    }
    let text: String
    let timestamp: Date
    let displayName: String
    var senderId: String
    
    init(text: String, sender: SenderType, timestamp: Date = Date(), messageId: String = UUID().uuidString) {
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
        let timestamp = try container.decode(Date.self, forKey: .timeStamp)
        
        var senderID = try? container.decode(String.self, forKey: .senderId)
        
        if senderID == nil {
            senderID = UUID().uuidString
        }
        
        let sender = Sender(senderId: senderID!, displayName: displayName)
        //let sender = SenderType(
        self.init(text: text, sender: sender, timestamp: timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(displayName, forKey: .displayName)
        try container.encode(senderId, forKey: .senderId)
        try container.encode(timestamp, forKey: .timeStamp)
        try container.encode(text, forKey: .text)
    }
    
    
}

struct Sender: SenderType {
    var senderId: String
    
    var displayName: String
    
    
}
