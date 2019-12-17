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
    
    func create(_ chatroom: ChatRoom) {
        databaseReference.child(chatroomsKey).child(chatroom.id)
            .setValue(chatroom)
    }
    
    func create(
        _ message: Message,
        in chatroom: ChatRoom,
        completion: (Error?) -> Void)
    {
        databaseReference.child(messagesKey).child(chatroom.id)
            .setValue(message)
    }
    
}
