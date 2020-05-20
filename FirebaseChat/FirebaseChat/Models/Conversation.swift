//
//  Conversation.swift
//  FirebaseChat
//
//  Created by Shawn James on 5/19/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {
    var text: String
    var displayName: String
    var senderId: String
    
    var sender: SenderType { Sender(senderId: senderId, displayName: displayName) }
    var messageId: String
    var sentDate: Date
    var kind: MessageKind { .text(text) }
}
