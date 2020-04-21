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
    let text: String
    let sender: SenderType
    let messageId: String
    let sentDate: Date
    
    var kind: MessageKind {
        return .text(text)
    }
    
//    var dictionaryRepresentation: [String: Any] {
//        
//    }
}

struct User: SenderType {
    let id: String
    let displayName: String
    
    var senderId: String {
        return id
    }
}
