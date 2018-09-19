//
//  ChatRoomController.swift
//  Firebase Chat
//
//  Created by Linh Bouniol on 9/18/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChatRoomController {
    
    var chatRooms = [ChatRoom]()
    
    var databaseReference = Database.database().reference()
    
    func fetchChatRoomsFromFirebase(completion: @escaping (Error?) -> Void) {
        databaseReference.child("chatRooms").observeSingleEvent(of: .value) { (dataSnapshot) in
            // turn dataSnapshot into dictionary
            guard let chatRoomsDictionary = dataSnapshot.value as? Dictionary<String, Dictionary<String, Any>> else {
                NSLog("Error grabbing snapshot values")
                completion(NSError())
                return
            }
            
            // grab value dictionary
            let chatRoomDictionaries = chatRoomsDictionary.map { $0.value }
            var chatRooms = [ChatRoom]()
            
            for chatRoomDictionary in chatRoomDictionaries {
                guard let chatRoom = ChatRoom(dictionary: chatRoomDictionary) else {
                    NSLog("Error creating chat room from dictionary")
                    completion(NSError())
                    return
                }
                chatRooms.append(chatRoom)
            }
            
            self.chatRooms = chatRooms
            completion(nil)
        }
    }
    
//    func fetchMessagesFromFirebase() {
//
//    }
    
    func createChatRoom(name: String, completion: @escaping (Error?) -> Void) {
        let chatRoom = ChatRoom(name: name)
        
        let chatRoomDictionary = chatRoom.dictionary
        databaseReference.child("chatRooms").child(chatRoom.chatRoomId).setValue(chatRoomDictionary) { (error, _) in
            DispatchQueue.main.async {
                self.chatRooms.append(chatRoom)
                completion(error)
            }
        }
    }
    
    func createMessage(sender: String, messageText: String, chatRoom: ChatRoom, completion: @escaping (Error?) -> Void) {
        let message = Message(sender: sender, messageText: messageText)
        
        let messageDictionary = message.dictionary
    databaseReference.child("chatRooms").child(chatRoom.chatRoomId).child("messages").child(message.messageId).setValue(messageDictionary) { (error, _) in
            DispatchQueue.main.async {
                if error != nil {
                    if let index = self.chatRooms.index(of: chatRoom) {
                        self.chatRooms[index].messages.append(message)
                    }
                }
                completion(error)
            }
        }
        
    }
}
