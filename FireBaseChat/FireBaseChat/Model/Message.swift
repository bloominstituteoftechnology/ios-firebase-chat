//
//  Message.swift
//  FireBaseChat
//
//  Created by Enrique Gongora on 3/24/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import Foundation
import MessageKit

struct Message: Codable, MessageType {
    var text: String
    var displayName: String
    var senderID: String { return UUID().uuidString }
    var sender: SenderType { return Sender(senderId: senderID, displayName: displayName) }
    var messageId: String
    var sentDate: Date
    var kind: MessageKind { return .text(text) }
}
