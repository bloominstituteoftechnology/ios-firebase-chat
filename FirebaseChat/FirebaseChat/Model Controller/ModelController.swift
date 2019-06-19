//
//  ModelController.swift
//  FirebaseChat
//
//  Created by Christopher Aronson on 6/18/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class ModelController {
    
    lazy var db = Firestore.firestore()
    
    var chatRooms = [ChatRoom]()
    var messages = [Message]()
    var currentUser: Sender?
    
    func createChatRoom(with chatRoomName: String, completion: @escaping (Error?) -> Void) {
        
        db.collection("chatRooms").document(chatRoomName).setData([ : ]) { error in
            
            if let error = error {
                completion(error)
                return
            }
            
            let newRoom = ChatRoom(chatRoomName: chatRoomName)
            self.chatRooms.append(newRoom)
            
            completion(nil)
        }
    }
    
    func fetchChatRooms(completion: @escaping (Error?) -> Void) {
        
        chatRooms = []
        
        db.collection("chatRooms").getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            for document in documents {
                let chat = ChatRoom(chatRoomName: document.documentID)
                
                self.chatRooms.append(chat)
            }
            
            completion(nil)
        }
    }
    
    func createMessage(in chatRoom: String, with message: Message, completion: @escaping (Error?) -> Void) {
        
        db.collection("chatRooms")
            .document(chatRoom)
            .collection("messages")
            .addDocument(data: [
                "senderDisplayName" : message.sender.displayName,
                "senderId" : message.sender.senderId,
                "sendDate" : message.sentDate,
                "messageId" : message.messageId,
                "text" : message.text
            ]) { error in
                
                if let error = error {
                    completion(error)
                    return
                }
                
                self.messages.append(message)
                
                completion(nil)
        }
    }
    
    func fetchMessages(in chatRoom: String, completion: @escaping (Error?) -> Void) {
        
        db.collection("chatRooms").document(chatRoom).collection("messages").getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            for document in documents {
                
                if let fetchedMessage = Message(data: document.data()) {
                    
                    self.messages.append(fetchedMessage)
                    
                    completion(nil)
                }
            }
        }
    }
    
}
