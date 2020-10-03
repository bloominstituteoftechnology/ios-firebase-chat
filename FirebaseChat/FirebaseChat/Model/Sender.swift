//
//  Sender.swift
//  FirebaseChat
//
//  Created by Rob Vance on 10/2/20.
//

import Foundation
import MessageKit


extension Message: MessageType {
    struct Sender: SenderType {
        let senderId: String
        let displayName: String
    }
    var sender: SenderType {
        Sender(senderId: UUID().uuidString, displayName: "")
    }
    
    var messageId: String {
        id
    }
    
    var sentDate: Date {
        date
    }
    
    var kind: MessageKind {
        .text(text)
    }
    
    
}
