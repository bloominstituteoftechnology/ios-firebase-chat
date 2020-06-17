//
//  Room.swift
//  FirebaseChat
//
//  Created by Cody Morley on 6/16/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import MessageKit

struct Room {
    let roomID: UUID
    let ownerID: UUID
    var title: String
    var messages: [Message]
    
    init(roomID: UUID = UUID(), ownerID: UUID, title: String, messages: [Message]) {
        self.roomID = roomID
        self.ownerID = ownerID
        self.title = title
        self.messages = messages
    }
}
