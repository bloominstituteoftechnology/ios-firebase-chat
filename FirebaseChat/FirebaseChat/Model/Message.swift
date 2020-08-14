//
//  Message.swift
//  FirebaseChat
//
//  Created by Clayton Watkins on 8/12/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation
import MessageKit

class Message {
    // MARK: - Properties
    var messageText: String
    var messageTimeStamp: Date
    var messageID: String
    let sentFrom: SenderType
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
    
    // MARK: - Initializer
    init(messageText: String, from sender: SenderType, messageID: String = UUID().uuidString, messageTimeStamp: Date = Date()) {
        self.messageText = messageText
        self.messageTimeStamp = messageTimeStamp
        self.messageID = messageID
        self.sentFrom = sender
    }
    
//    func dictionize() -> Any {
//        return [
//            "senderID": sentFrom.senderId,
//            "senderName": sentFrom.displayName,
//            "message": messageText,
//            "timestamp": 
//        ]
//    }
}

// MARK: - Extension
extension Message: MessageType {
    var sender: SenderType {
        return Sender(senderId: sentFrom.senderId, displayName: sentFrom.displayName)
    }

    var messageId: String {
        return messageID
    }

    var sentDate: Date {
        return messageTimeStamp
    }

    var kind: MessageKind {
        return .text(messageText)
    }
}
