//
//  ChatRoomController.swift
//  FirebaseChat
//
//  Created by Elizabeth Thomas on 8/10/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import Foundation
import Firebase
import MessageKit

class ChatRoomController {
    
    let chatRoomRef = Database.database().reference().child("chatRooms")
    let messagesRef = Database.database().reference().child("messagesByChatRoomId")
    var chatRooms = [ChatRoom]()

    func createChatRoom(title: String) {
        let newChatRoom = ChatRoom(title: title)
        
        chatRoomRef.child(newChatRoom.id).setValue(["title" : newChatRoom.title])
        fetchChatRooms()
    }
    
    func fetchChatRooms() {
        chatRoomRef.observeSingleEvent(of: .value) { snapshot in
            guard let snapDict = snapshot.value as? [String: [String : Any]] else { return }
            
            self.chatRooms.removeAll()
            for child in snapDict {
                guard let chatRoom = ChatRoom(id: child.key, dict: child.value) else { continue }
                self.chatRooms.append(chatRoom)
            }
        }
    }
    
    func createMessage(message: Message, chatRoom: ChatRoom) {
        messagesRef.child(chatRoom.id).child(message.id).setValue([
            "text" : message.text,
            "date" : String(describing: message.date)
        ])
    }
    
    func fetchMessages(_ chatRoom: ChatRoom, completion: @escaping ([Message]) -> Void) {
        messagesRef.child(chatRoom.id).observeSingleEvent(of: .value) { snapshot in
            guard let messageDict = snapshot.value as? [String: [String: Any]] else {
                completion([])
                return
            }
            
            var messages: [Message] = []
            for child in messageDict {
                guard let message = Message(id: child.key, dict: child.value) else { continue }
                messages.append(message)
            }
            completion(messages)
        }
    }
    
}
