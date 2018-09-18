//
//  ChatController.swift
//  ios-firebase-chat
//
//  Created by De MicheliStefano on 18.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChatController {
    
    init(ref: DatabaseReference) {
        self.ref = ref
    }
    
    var ref: DatabaseReference!
    var chatRooms = [ChatRoom]()
    
    func createChatRoom(with title: String, completion: @escaping () -> Void) {
        let chatRoom = ChatRoom(title: title)
        let chatRoomDict = chatRoom.toDictionary()
        self.ref.child("chatRooms").child(chatRoom.id).setValue(chatRoomDict)
    }
    
    func createMessage(with text: String, sender: String, chatRoomId: String, completion: @escaping () -> Void) {
        let message = Message(text: text, sender: sender, chatRoomId: chatRoomId)
        let messageDict = message.toDictionary()
        self.ref.child("chatRooms").child(chatRoomId).child("messages").child(message.id).setValue(messageDict)
    }
    
    func fetchChatRoom(completion: @escaping () -> Void) {
        self.ref.child("chatRooms").observeSingleEvent(of: .value) { (snapshot) in
            let values = snapshot.value as? NSDictionary ?? [:]
            
            for value in values {
                guard let chatRoom = value.value as? ChatRoom else { continue }
                self.chatRooms.append(ChatRoom(id: chatRoom.id, title: chatRoom.title, messages: chatRoom.messages))
                
//                let chatRoom = value.value as AnyObject
//                let id = chatRoom["id"] as? String ?? ""
//                let title = chatRoom["title"] as? String ?? ""
//                let messages = chatRoom["messages"] as? [Message] ?? []

                //self.chatRooms.append(ChatRoom(id: id, title: title, messages: messages))
            }
        }
    }
    
    func fetchMessages(for chatRoom: ChatRoom, completion: @escaping () -> Void) {
        self.ref.child("chatRooms").child(chatRoom.id).child("messsages").observeSingleEvent(of: .value) { (snapshot) in
            let values = snapshot.value as? NSDictionary ?? [:]
            var messages = [Message]()
            
            for value in values {
                guard let message = value.value as? Message else { continue }
                messages.append(Message(id: message.id,
                                        text: message.text,
                                        timestamp: message.timestamp,
                                        sender: message.sender,
                                        chatRoomId: message.chatRoomId))
            }
            
            guard let index = self.chatRooms.index(of: chatRoom) else { return }
            var newChatRoom = self.chatRooms[index]
            newChatRoom.messages = messages
            self.chatRooms.remove(at: index)
            self.chatRooms.insert(newChatRoom, at: index)
            
        }
    }
    
}
