//
//  Message.swift
//  FirebaseChat
//
//  Created by Joshua Rutkowski on 4/26/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import Foundation
import MessageKit


struct Message: Codable, MessageType {
    var displayName: String
    var senderID: String { return UUID().uuidString }
    var sender: SenderType { return Sender(senderId: senderID, displayName: displayName) }
    var messageId: String
    var sentDate: Date
    var text: String
}
