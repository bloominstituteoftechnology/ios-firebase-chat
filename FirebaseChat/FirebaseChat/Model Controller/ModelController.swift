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
    
    // MARK: - Firestore properties - Needs to be lazy so App delegate can load Firebase first
    lazy var db = Firestore.firestore()
    
    // MARK: - Properties
    var chatRooms = [String]()
    var messages = [Message]()
    var currentUser: Sender?
    
    // MARK: - Chat room functions
    func createChatRoom(with chatRoomName: String, completion: @escaping (Error?) -> Void) {
        
        //Creates empty chat room tiled with the chatRoomName string
        db.collection("chatRooms").document(chatRoomName).setData([ : ]) { error in
            
            if let error = error {
                completion(error)
                return
            }
            
            
            self.chatRooms.append(chatRoomName)
            
            completion(nil)
        }
    }
    
    func fetchChatRooms(completion: @escaping (Error?) -> Void) {
        
        // Empties the chatRooms array so no doubles are produced when fetching
        chatRooms = []
        
        //Gets the document id for every chat room and adds that to the chat room array so it can be used to title the cells in the table view
        db.collection("chatRooms").getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            for document in documents {
                let chat = document.documentID
                
                self.chatRooms.append(chat)
            }
            
            completion(nil)
        }
    }
    
    // MARK: - Message Functions
    func createMessage(in chatRoom: String, with message: Message, completion: @escaping (Error?) -> Void) {
        
        //Firestore does not work with JSON so I had to implement a different way of giving the information to Firestore
        //This creates a dictionary with all of the properties from the Message type
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
        
        // Empties the messages array so no doubles are produced when fetching
        messages = []
        
        //Gets messages from the chat room in chatRoom String
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
