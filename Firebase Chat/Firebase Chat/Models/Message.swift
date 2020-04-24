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
        
    init(text: String, displayName: String, timestamp: Date = Date()) {
        self.text = text
        self.displayName = displayName
        self.timestamp = timestamp
    }
}

extension Message: MessageType {
    var sender: SenderType {
        return Sender(senderId: UUID().uuidString, displayName: "")
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

struct Sender: SenderType {
    let senderId: String
    let displayName: String
}
