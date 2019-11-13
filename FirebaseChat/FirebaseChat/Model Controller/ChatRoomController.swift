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
    
    init() {
        ref = Database.database().reference()
    }
    
    // Create a chat room in Firebase
    func createChatRoom(title: String) {
        let chatRoom = ChatRoom(title: title)
        self.ref.child("ChatRoom").child(chatRoom.identifier).setValue(["title": chatRoom.title, "messages": chatRoom.messages, "identifier": chatRoom.identifier]) { (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
            self.chatRooms.append(chatRoom)
          }
        }
    }
    
    // Fetch chat rooms from Firebase
    func fetchChatRooms() {
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists() { return }
            
//            guard let title = snapshot.value(forKey: "title") as? String,
//                let messages = snapshot.value(forKey: "messages") as? [ChatRoom.Message],
//                let identifier = snapshot.value(forKey: "identifier") as? String else {
//                    return
//            }
//
//            let chatRoom = ChatRoom(title: title, messages: messages, identifier: identifier)
//
                
            let chatRoomDict = snapshot.value as? [String: ChatRoom] ?? [:]
            
            let chatRooms: [ChatRoom] = chatRoomDict.map({$0.value})
            self.chatRooms = chatRooms
        }
    }
    // Create a message in a chat room in Firebase
    // Fetch messages in a chat room from Firebase
}
