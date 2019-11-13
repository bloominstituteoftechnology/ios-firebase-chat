//
//  ChatRoomController.swift
//  FirebaseChat
//
//  Created by Gi Pyo Kim on 11/12/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation
import Firebase

class ChatRoomController {
    
    var ref: DatabaseReference!
    var chatRooms: [ChatRoom] = []
    var currentUser: Sender?
    
    init() {
        ref = Database.database().reference()
    }
    
    // Create a chat room in Firebase
    func createChatRoom(title: String, completion: @escaping () -> Void) {
        let chatRoom = ChatRoom(title: title)
        ref.child("ChatRooms").child(chatRoom.identifier).setValue(chatRoom.dictionaryRepresentation) { (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
            completion()
            return
          } else {
            print("Data saved successfully!")
            self.chatRooms.append(chatRoom)
            completion()
          }
        }
    }
    
    // Fetch chat rooms from Firebase
    func fetchChatRooms(completion: @escaping () -> Void) {
        
        ref.child("ChatRooms").observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists() { completion(); return }
            
            guard let chatRoomDicts = snapshot.value as? [String: Any] else {
                NSLog("Invalid chatRoomDict")
                completion()
                return
            }
            
            self.chatRooms = []
            for chatRoomDict in chatRoomDicts {
                guard let chatRoomRep = chatRoomDict.value as? [String: Any],
                    let chatRoom = ChatRoom(dictionary: chatRoomRep) else { continue }
                self.chatRooms.append(chatRoom)
            }
            completion()
        }
    }
    
    // Create a message in a chat room in Firebase
    func createMessage(chatRoom: ChatRoom, text: String, sender: Sender, completion: @escaping () -> Void) {
        let message = ChatRoom.Message(text: text, sender: sender)
        
        ref.child("ChatRooms").child(chatRoom.identifier).child("messages").setValue(message.dinctionaryRepresentation) { (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
            completion()
            return
          } else {
            print("Data saved successfully!")
            chatRoom.messages.append(message)
            completion()
          }
        }
    }
    
    
    
    // Fetch messages in a chat room from Firebase
}
