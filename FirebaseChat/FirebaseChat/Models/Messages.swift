//
//  Messages.swift
//  FirebaseChat
//
//  Created by Christopher Aronson on 6/18/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {
    
    var messageId: String
    var sender: SenderType
    var sentDate: Date
    var kind: MessageKind
    var text: String
    
    
    init?(data: [String: Any]) {
        guard let sender = data["sender"] as? SenderType,
        let timestamp = data["timestamp"] as? Date,
        let text = data["text"] as? String,
        let messageId = data["messageId"] as? String
        else { return nil }
        
        self.sender = sender
        self.sentDate = timestamp
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

