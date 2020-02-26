//
//  ChatRoomController.swift
//  Firebase Chat
//
//  Created by Michael on 2/25/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class ChatRoomController {
    
    let ref: DatabaseReference = Database.database().reference()
    
    var chatRooms: [ChatRoom] = []
    
    var currentUser: Sender?
    
    func createChatRoom(with title: String) {
        let newChatRoom = ChatRoom(title: title)
        let dictionaryChatRoom: [String: Any] = ["identifier" : newChatRoom.identifier,
                                                 "title" : newChatRoom.title,
                                                 "messages" : ["messages": newChatRoom.messages]]
        
        
        self.chatRooms.append(newChatRoom)
        
        self.ref.child(newChatRoom.identifier).setValue(dictionaryChatRoom) {
            (error: Error?, ref: DatabaseReference) in
            if let error = error {
                NSLog("Data could not be saved: \(error)")
            } else {
                NSLog("Data saved successfully!")
            }
        }
    }
    
//    func createMessage(in chatRoom: ChatRoom, with message: String, sender: Sender) {
//        guard let index = chatRooms.firstIndex(of: chatRoom) else { return }
//        let title = "That New New Chat Room"
//        let newChatRoom = ChatRoom(title: title)
//        let message = ChatRoom.Message(message: message, sender: sender)
//        let dictMessage: [String : Any] = ["message" : message.message,
//                                           "username" : message.username,
//                                           "sentDate" : message.sentDate,
//                                           "senderID" : message.senderID,
//                                           "messageId" : message.messageId]
//        let messageByID: [String : Any] = [message.messageId : dictMessage]
//        
//        chatRooms[index].messages.append(message)
//
//        let selectedChatRoom = chatRooms[index]
//        let dictionaryChatRoom: [String : Any] = ["identifier" : newChatRoom.identifier,
//                                                  "title" : newChatRoom.title,
//                                                  "messages" : messageByID]
//        
//        self.ref.child(newChatRoom.identifier).setValue(dictionaryChatRoom) {
//            (error: Error?, ref: DatabaseReference) in
//            if let error = error {
//                NSLog("Data could not be updated: \(error)")
//            } else {
//                NSLog("Chat Room updated successfully!")
//            }
//        }
//    }
    
    func fetchChatRoomsCodable(completion: @escaping () -> ()) {
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            do {
                let fetchedChatRooms = Array(try FirebaseDecoder().decode([String : ChatRoom].self, from: value).values)
                self.chatRooms = fetchedChatRooms
                DispatchQueue.main.async {
                    completion()
                }
            } catch let error {
                NSLog("Error decoding Chat Room Objects: \(error)")
                DispatchQueue.main.async {
                    completion()
                }
                return 
            }
        })
    }
    
    func createChatRoomCodable(with title: String) {
        let newChatRoom = ChatRoom(title: title)
        
        self.chatRooms.append(newChatRoom)
        let data = try! FirebaseEncoder().encode(newChatRoom)
        self.ref.child("\(newChatRoom.identifier)").setValue(data) {
            (error: Error?, ref: DatabaseReference) in
            if let error = error {
                NSLog("Data could not be saved: \(error)")
            } else {
                NSLog("Data saved successfully!")
            }
        }
    }
    
    func createMessageCodable(in chatRoom: ChatRoom, with message: String, sender: Sender) {
        guard let index = chatRooms.firstIndex(of: chatRoom) else { return }
        
        
        let message = ChatRoom.Message(message: message, sender: sender)
        let data = try! FirebaseEncoder().encode(message)
        chatRooms[index].messages.append(message)

        let selectedChatRoom = chatRooms[index]
        
        self.ref.child("\(selectedChatRoom.identifier)/messages").child("\(message.senderID)").setValue(data)
            
        }
    
    func deleteChatRoom(chatRoom: ChatRoom) {
        let chatRoomToDelete = chatRoom
        let identifier = chatRoomToDelete.identifier
        ref.child(identifier).removeValue()
        guard let index = chatRooms.firstIndex(of: chatRoom) else { return }
        chatRooms.remove(at: index)
    }
    
    func createChatRoomAndMessageCodable(title: String, with message: String, sender: Sender) {
        
        let chatRoom = ChatRoom(title: title)
        let message = ChatRoom.Message(message: message, sender: sender)
        
        let newChatRoom = ChatRoom(title: chatRoom.title, messages: [message], identifier: chatRoom.identifier)
        
        let data = try! FirebaseEncoder().encode(newChatRoom)
        self.ref.child(newChatRoom.identifier).setValue(data) {
            (error: Error?, ref: DatabaseReference) in
            if let error = error {
                NSLog("Data could not be saved: \(error)")
            } else {
                NSLog("Data saved successfully!")
            }
        }
    }
}
