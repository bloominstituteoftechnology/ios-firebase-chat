//
//  Message.swift
//  ios-firebase-chat
//
//  Created by Matthew Martindale on 6/7/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import Foundation
import MessageKit
import Firebase

struct Message {
    let id: UUID
    let message: String
    let date: Date
    let sentBy: SenderType
    
    init(id: UUID = UUID(), message: String, date: Date = Date(), sentBy sender: SenderType) {
        self.message = message
        self.sentBy = sender
        self.id = id
        self.date = date
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let senderId = value["senderId"] as? String,
            let senderName = value["senderName"] as? String,
            let message = value["message"] as? String,
            let date = value["timestamp"] else {
                return nil
        }
        
        self.id = UUID(uuidString: snapshot.key) ?? UUID()
        self.sentBy = Sender(id: senderId, displayName: senderName)
        self.message = message
        self.date = date as! Date
    }
    
    func intoDictionary() -> [String : Any] {
        return [
            "senderID": sentBy.senderId,
            "senderName": sentBy.displayName,
            "message": message,
            "date": date
        ]
    }
    
}

extension Message: MessageType {
    var sender: SenderType {
        return sentBy
    }
    
    var messageId: String {
        id.uuidString
    }
    
    var sentDate: Date {
        return date
    }
    
    var kind: MessageKind {
        return .text(message)
    }
    
    
}
