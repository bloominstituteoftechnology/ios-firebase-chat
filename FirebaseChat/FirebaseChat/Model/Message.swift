//
//  Message.swift
//  FirebaseChat
//
//  Created by Jessie Ann Griffin on 4/26/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import Foundation
import MessageKit

struct Message: Codable, Equatable {
    
    let text: String
    let timestamp: Date
    let displayName: String
    
    init(text: String, displayName: String, timestamp: Date = Date()) {
        self.text = text
        self.displayName = displayName
        self.timestamp = timestamp
        
    }
}

extension Message: MessageType {
    var sender: SenderType {
        return Sender(senderId: "", displayName: "") // first just make it work
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

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}
