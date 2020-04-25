//
//  Message.swift
//  Firebase Chat
//
//  Created by David Wright on 4/24/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import MessageKit

struct Message: Codable, Equatable {
    
    let text: String
    let displayName: String
    let timestamp: Date
    let senderID: String
    let messageID: String
        
    init(text: String, sender: Sender, timestamp: Date = Date(), messageID: String = UUID().uuidString) {
        self.text = text
        self.displayName = sender.displayName
        self.timestamp = timestamp
        self.senderID = sender.senderId
        self.messageID = messageID
    }
}

extension Message: MessageType {
    var sender: SenderType {
        return Sender(senderId: senderID, displayName: displayName)
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

// MARK: - Custom Types

public struct Sender: SenderType {
    public let senderId: String
    public let displayName: String
}
