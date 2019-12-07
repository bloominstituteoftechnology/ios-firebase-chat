//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by John Kouris on 12/7/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import UIKit
import Firebase

struct ChatRoom {
    var uid: String
    var title: String
    var messages: [Message]
}

struct Message {
    var senderID: String
    var text: String
    var timestamp: Date
    var author: String
}
