//
//  ChatRoom.swift
//  Chat
//
//  Created by Chris Dobek on 5/20/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import MessageKit

struct ChatRoom {
}


struct Message: MessageType {
    var text: String
    var displayName: String
    var senderId: String

    var sender: SenderType { Sender(senderId: senderId, displayName: displayName) }
    var messageId: String
    var sentDate: Date
    var kind: MessageKind { .text(text) }
}
