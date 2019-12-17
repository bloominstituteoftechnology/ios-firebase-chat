//
//  Message.swift
//  FirebaseChat
//
//  Created by Jon Bash on 2019-12-17.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var text: String
    var sentDate: Date
    var messageId: String
    
    var kind: MessageKind { return .text(text) }
    
    init(sender: Sender,
         text: String,
         sentDate: Date = Date(),
         messageId: String = UUID().uuidString)
    {
        self.sender = sender
        self.text = text
        self.sentDate = sentDate
        self.messageId = messageId
    }
    
}

// MARK: - Codable

extension Message: Codable {
    enum CodingKeys: String, CodingKey {
        case senderName
        case senderID
        case text
        case sentDate
        case messageId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let senderName = try container.decode(String.self, forKey: .senderName)
        let senderID = try container.decode(String.self, forKey: .senderID)
        let text = try container.decode(String.self, forKey: .text)
        let sentDate = try container.decode(Date.self, forKey: .sentDate)
        let messageID = try container.decode(String.self, forKey: .messageId)
        
        self.init(
            sender: Sender(
                senderId: senderID,
                displayName: senderName),
            text: text,
            sentDate: sentDate,
            messageId: messageID)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(sender.displayName, forKey: .senderName)
        try container.encode(sender.senderId, forKey: .senderID)
        try container.encode(text, forKey: .text)
        try container.encode(sentDate, forKey: .sentDate)
        try container.encode(messageId, forKey: .messageId)
    }
}
