//
//  Message.swift
//  Chat
//
//  Created by Kat Milton on 8/20/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation
import MessageKit
import Firebase

struct Message: MessageType {
    var sender: SenderType {
        return Sender(displayName: displayName, senderId: senderID)
    }
    let chatroom: ChatRoom?
    var text: String
    var displayName: String
    var senderID: String
    var messageId: String
    
    // MARK: - MessageType
    var sentDate: Date {
        return Date() }
    var kind: MessageKind {
        return .text(text) }
    
    
}

//
//struct Message: MessageType {
//    var messageId: String
//    let text: String
//    var sender: SenderType
//    let sentDate: Date
//
//    var kind: MessageKind {
//        return .text(text)
//    }
//
//    init(text: String, sender: Sender, messageId: UUID = UUID(), sentDate: Date = Date()) {
//        self.text = text
//        self.sender = sender
//        self.messageId = messageId.uuidString
//        self.sentDate = sentDate
//    }
//
//    init?(data: [String: Any]) {
//        guard let timestamp = data["sentDate"] as? Date else { return nil }
//        guard let senderId = data["senderId"] as? String else { return nil }
//        guard let senderDisplayName = data["displayName"] as? String else { return nil }
//        guard let text = data["text"] as? String else { return nil }
//        guard let messageId = data["messageId"] as? String else { return nil }
//
//        let sender = Sender(displayName: senderDisplayName, senderId: senderId)
//
//        self.sender = sender
//        self.sentDate = timestamp
//        self.messageId = messageId
//        self.text = text
//
//    }

    

   
//}

