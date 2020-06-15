//
//  ModelController.swift
//  FirebaseChat
//
//  Created by Chad Parker on 2020-06-09.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import Foundation
import Firebase

protocol ModelControllerDelegate: AnyObject {
   func chatRoomsWereUpdated()
}

class ModelController {
   
   weak var delegate: ModelControllerDelegate!
   let chatRoomsRef = Database.database().reference().child("chatRooms")
   let messagesRef = Database.database().reference().child("messagesByChatRoomId")
   
   var chatRooms: [ChatRoom] = [] {
      didSet {
         delegate.chatRoomsWereUpdated()
      }
   }
   
   init() {
      fetchChatRooms()
   }
   
   func createChatRoom(_ name: String) {
      let newChatRoom = ChatRoom(name: name)
      chatRoomsRef.child(newChatRoom.id).setValue([
         "name": newChatRoom.name
      ])
      fetchChatRooms()
   }
   
   func fetchChatRooms() {
      chatRoomsRef.observeSingleEvent(of: .value) { snapshot in
         guard let snapDict = snapshot.value as? [String: [String: Any]] else { return }
         
         self.chatRooms.removeAll()
         for child in snapDict {
            guard let chatRoom = ChatRoom(id: child.key, dict: child.value) else { continue }
            self.chatRooms.append(chatRoom)
         }
      }
   }
   
   func createMessageInChatRoom(message: Message, chatRoom: ChatRoom) {
      messagesRef.child(chatRoom.id).child(message.id).setValue([
         "text": message.text,
         "date": String(describing: message.date),
      ])
   }
   
   func fetchMessagesInChatRoom(_ chatRoom: ChatRoom, completion: @escaping ([Message]) -> Void) {
      messagesRef.child(chatRoom.id).observeSingleEvent(of: .value) { snapshot in
         guard let messagesDict = snapshot.value as? [String: [String: Any]] else {
            completion([])
            return
         }
         
         var messages: [Message] = []
         for child in messagesDict {
            guard let message = Message(id: child.key, dict: child.value) else { continue }
            messages.append(message)
         }
         completion(messages)
      }
   }
}
