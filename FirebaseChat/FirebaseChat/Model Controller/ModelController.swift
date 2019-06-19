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
    
    func createMessage(in chatRoom: ChatRoom, with message: Message, completion: @escaping (Error?) -> Void) {
        
        db.collection("chatRooms")
            .document(chatRoom.chatRoomName)
            .collection("messages")
            .addDocument(data: [
                "sender" : message.sender,
                "timestamp" : message.timestamp,
                "message" : message.message
            ]) { error in
                
                if let error = error {
                    completion(error)
                    return
                }
                
                completion(nil)
        }
    }
    
    func fetchMessages(in chatRoom: ChatRoom, completion: @escaping (Error?) -> Void) {
        
        db.collection("chatRooms").document(chatRoom.chatRoomName).collection("messages").getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            for document in documents {
                
                print(document.data())
                
            }
        }
    }
    
}


