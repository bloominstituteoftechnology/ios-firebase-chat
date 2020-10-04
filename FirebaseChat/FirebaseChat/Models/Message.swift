//
//  Message.swift
//  FirebaseChat
//
//  Created by Cora Jacobson on 10/3/20.
//

import Foundation
import MessageKit

struct Message: Codable, Equatable, MessageType {
    
    enum CodingKeys: String, CodingKey {
        case messageId
        case displayName
        case senderId
        case text
        case sentDate
    }
    
    // MARK: - Message Type
    var sender: SenderType {
        return Sender(senderId: senderId, displayName: displayName)
    }
    var messageId: String
    var sentDate: Date
    var kind: MessageKind { return .text(text)}
    let text: String
    let displayName: String
    let senderId: String
    
    init(text: String, sender: Sender, sentDate: Date = Date(), messageId: String = UUID().uuidString) {
        self.text = text
        self.displayName = sender.displayName
        self.senderId = sender.senderId
        self.sentDate = sentDate
        self.messageId = messageId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let messageId = try container.decode(String.self, forKey: .messageId)
        let text = try container.decode(String.self, forKey: .text)
        let displayName = try container.decode(String.self, forKey: .displayName)
        let sentDate = try container.decode(Date.self, forKey: .sentDate)
        let senderId = try container.decode(String.self, forKey: .senderId)
                
        self.messageId = messageId
        self.text = text
        self.displayName = displayName
        self.senderId = senderId
        self.sentDate = sentDate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(messageId, forKey: .messageId)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(senderId, forKey: .senderId)
        try container.encode(sentDate, forKey: .sentDate)
        try container.encode(text, forKey: .text)
    }
    
}
