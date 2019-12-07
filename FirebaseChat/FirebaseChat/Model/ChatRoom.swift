//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by John Kouris on 12/7/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import UIKit
import Firebase
import MessageKit

struct ChatRoom {
    var uid: String
    var title: String
    var messages: [Message]
}

struct Message {
    var senderID: String
    var text: String
    var timestamp: Date
    var author: String
}


extension Message: MessageType {
    var sender: SenderType {
        return Sender(senderId: senderID, displayName: author)
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
