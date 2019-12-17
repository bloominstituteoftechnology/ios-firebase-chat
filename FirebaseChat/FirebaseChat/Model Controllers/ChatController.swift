//
//  ChatController.swift
//  FirebaseChat
//
//  Created by Jon Bash on 2019-12-17.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChatController {
    var databaseReference: DatabaseReference
    
    let chatroomsKey = "chatrooms"
    let messagesKey = "messages"
    
    var chatrooms = [ChatRoom]()
    
    var chatroomObserver: UInt?
    
    init() {
        databaseReference = Database.database().reference()
    }
}
