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
        .text(text)
    }
    
}

struct Sender: SenderType {
    let senderId: String
    let displayName: String
}
