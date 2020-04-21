//
//  ChatController.swift
//  FirebaseChat
//
//  Created by Shawn Gee on 4/21/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation
import FirebaseDatabase

var ref: DatabaseReference = Database.database().reference()


func createChatRoom(name: String) -> ChatRoom {
    let chatRoomID = UUID().uuidString
    ref.child("chatRooms").child(chatRoomID).setValue(name, forKey: "name")
    
    return ChatRoom(name: name, messages: [], id: chatRoomID)
}



