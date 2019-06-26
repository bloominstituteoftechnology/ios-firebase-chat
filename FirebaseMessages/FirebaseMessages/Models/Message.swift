//
//  Message.swift
//  FirebaseMessages
//
//  Created by Jonathan Ferrer on 6/25/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {
    let text: String

    let senderName: String
    let senderID: String
    var sender: SenderType {
        return User(id: senderID, displayName: senderName)
    }
    let identifier: String
    var messageId: String {
        return identifier
    }
    let sentDate: Date

    var kind: MessageKind {
        return .text(text)
    }

    init(text: String, senderName: String, senderID: String, id: String = UUID().uuidString, sentDate: Date = Date()) {
        self.text = text
        self.senderName = senderName
        self.senderID = "\(senderID)"
        self.identifier = id
        self.sentDate = sentDate
    }

    init?(dictionary: [String: Any]) {
        guard let text = dictionary["text"] as? String,
            let senderName = dictionary["senderName"] as? String,
            let senderID = dictionary["senderID"] as? String,
            let id = dictionary["id"] as? String,
            let sentDate = dictionary["sentDate"] as? TimeInterval else { return nil}

        self.text = text
        self.senderName = senderName
        self.senderID = "\(senderID)"
        self.identifier = id
        self.sentDate = Date(timeIntervalSince1970: sentDate)
    }

    var dictionaryRep: [String: Any] {
        return ["text": text, "senderName": senderName, "senderID": senderID, "id": identifier, "sentDate": sentDate.timeIntervalSince1970]
    }
}
