//
//  ChatRoomController.swift
//  Firebase Chat
//
//  Created by David Wright on 4/24/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import MessageKit
import Firebase

class ChatRoomController {
    
    // MARK: Properties

    var chatRooms: [ChatRoom] = []
    var currentUser: Sender? = Sender(senderId: UUID().uuidString, displayName: "Default User")
    
    var ref: DatabaseReference!
    
    // MARK: Methods

    func fetchChatRooms(completion: @escaping () -> Void) {
        // TODO: Test fetchChatRooms()
        ref.child("chatRooms").observe(DataEventType.value, with: { snapshot in
            let chatDict = snapshot.value as? [String : ChatRoom] ?? [:]
            self.chatRooms = Array(chatDict.values)
            completion()
        })
    }
    
    func fetchMessages(in chatRoom: ChatRoom, completion: @escaping () -> Void) {
        // TODO: Test fetchMessages()
        ref.child("messages").child(chatRoom.id).child("messages").observe(DataEventType.value, with: { snapshot in
            let messagesDict = snapshot.value as? [String : Message] ?? [:]
            chatRoom.messages = Array(messagesDict.values)
            completion()
        })
    }
    
    func createChatRoom(titled title: String, completion: @escaping () -> Void) {
        // TODO: Test createChatRoom()
        let chatRoom = ChatRoom(title: title)
        chatRooms.append(chatRoom)
        self.ref.child("chatRooms").setValue([chatRoom.id: chatRoom])
        completion()
    }
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, from sender: Sender, completion: @escaping () -> Void) {
        // TODO: Test createMessage()
        let message = Message(text: text, sender: sender)
        chatRoom.messages.append(message)
        self.ref.child("messages").child(chatRoom.id).child("messages").setValue([message.messageID: message])
        completion()
    }
    
    // MARK: - Initializers

    init() {
        self.ref = Database.database().reference()
    }
}
