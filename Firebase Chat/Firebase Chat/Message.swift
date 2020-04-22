//
//  Message.swift
//  Firebase Chat
//
//  Created by Tobi Kuyoro on 21/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import Firebase
import MessageKit

struct Message: Codable, Equatable, MessageType {
    let text: String
    let displayName: String
    let messageId: String
    let senderId: String
    let sentDate: Date
    
    var sender: SenderType {
        return Sender(senderId: senderId, displayName: displayName)
    }
    
    var kind: MessageKind {
        return .text(text)
    }
    
    enum MessageKeys: String, CodingKey {
        case text, displayName, messageId, senderId, sendDate
    }
    
    init(text: String, displayName: String, messageID: String, senderID: String, sentDate: Date) {
        self.text = text
        self.displayName = displayName
        self.messageId = messageID
        self.senderId = senderID
        self.sentDate = sentDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MessageKeys.self)
        let text = try container.decode(String.self, forKey: .text)
        let displayName = try container.decode(String.self, forKey: .displayName)
        let messageId = try container.decode(String.self, forKey: .messageId)
        let senderId = try container.decode(String.self, forKey: .senderId)
        let sentDate = try container.decode(Date.self, forKey: .sendDate)
        let sender = Sender(senderId: senderId, displayName: displayName)
        self.init(text: text, displayName: displayName, messageID: messageId, senderID: senderId, sentDate: sentDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MessageKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(messageId, forKey: .messageId)
        try container.encode(senderId, forKey: .senderId)
        try container.encode(sentDate, forKey: .sendDate)
    }
}
