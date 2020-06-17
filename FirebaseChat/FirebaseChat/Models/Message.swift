//
//  Message.swift
//  FirebaseChat
//
//  Created by Cody Morley on 6/16/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    var contents: String
    
    init(sender: User, messageID: String = UUID().uuidString, sentDate: Date = Date(), kind: MessageKind, contents: String) {
        self.sender = sender
        self.messageId = messageID
        self.sentDate = sentDate
        self.kind = kind
        self.contents = contents
    }
}
