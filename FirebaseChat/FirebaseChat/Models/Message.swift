//
//  Message.swift
//  FirebaseChat
//
//  Created by Shawn Gee on 4/21/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {
    let messageText: String
    let messageId: String
    let sentDate: Date
    let sender: SenderType
    
    var kind: MessageKind {
        return .text(messageText)
    }
    
    enum Keys {
        static let messageText = "messageText"
        static let messageId = "messageId"
        static let sentDate = "sentDate"
        static let sender = "sender"
    }
    
    init?(with dictionary: [String: Any]) {
        guard
            let messageText = dictionary[Keys.messageText] as? String,
            let messageId = dictionary[Keys.messageId] as? String,
            let sentDate = dictionary[Keys.sentDate] as? TimeInterval,
            let senderDict = dictionary[Keys.sender] as? [String: String],
            let sender = User(with: senderDict) else { return nil }
        
        self.messageText = messageText
        self.messageId = messageId
        self.sentDate = Date(timeIntervalSinceReferenceDate: sentDate)
        self.sender = sender
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [
            Keys.messageText: messageText,
            Keys.messageId: messageId,
            Keys.sentDate: sentDate.timeIntervalSinceReferenceDate,
            Keys.sender: sender.dictionaryRepresentation
        ]
    }
}
