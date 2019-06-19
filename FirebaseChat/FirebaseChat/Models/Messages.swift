//
//  Messages.swift
//  FirebaseChat
//
//  Created by Christopher Aronson on 6/18/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import MessageKit
import Firebase

struct Message: MessageType {
    
    var messageId: String
    var sender: SenderType
    var sentDate: Date
    var kind: MessageKind
    var text: String
    
    
    init?(data: [String: Any]) {
        guard let timestamp = data["sendDate"] as? Timestamp else { return nil }
        guard let senderId = data["senderId"] as? String else { return nil }
        guard let senderDisplayName = data["senderDisplayName"] as? String else { return nil }
        guard let text = data["text"] as? String else { return nil }
        guard let messageId = data["messageId"] as? String else { return nil }
        
        
        let sender = Sender(displayName: senderDisplayName, senderId: senderId)
        
        self.sender = sender
        self.sentDate = timestamp.dateValue()
        self.kind = .text(text)
        self.messageId = messageId
        self.text = text
    }
    
    init(sender: SenderType, sendDate: Date, messageId: String, text: String) {
        
        self.sender = sender
        self.sentDate = sendDate
        self.kind = .text(text)
        self.messageId = messageId
        self.text = text
    }
}

