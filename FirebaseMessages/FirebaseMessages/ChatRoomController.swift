//
//  ChatRoomController.swift
//  FirebaseMessages
//
//  Created by Jonathan Ferrer on 6/25/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation
import MessageKit
import FirebaseDatabase

class ChatRoomController {

    func createChatRoom(name: String) {
        let ref = Database.database().reference()
        let chatRoom = ChatRoom(name: name)
        ref.child("chatRooms").child(chatRoom.identifier).setValue(chatRoom.dictionaryRep)
        chatRooms.append(chatRoom)
    }

    func createMessage(chatRoom: ChatRoom ,text: String, user: Sender) {
        let ref = Database.database().reference()
        let message = Message(text: text, senderName: user.displayName, senderID: user.id)
        ref.child("chatRooms").child(chatRoom.identifier).child("messages").child(message.identifier).setValue(message.dictionaryRep)
        chatRoom.messages.append(message)
    }

    func fetchChatRoom() {
        let ref = Database.database().reference().child("chatRooms")
    }


    var chatRooms: [ChatRoom] = []

}

