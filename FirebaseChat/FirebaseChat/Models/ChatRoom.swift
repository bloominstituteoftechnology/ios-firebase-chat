//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Ciara Beitel on 10/15/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import Foundation

struct ChatRoom {
    var id: UUID
    var messages: [Message?]
    var name: String
}
