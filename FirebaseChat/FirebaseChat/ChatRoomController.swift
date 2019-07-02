//
//  ChatRoomController.swift
//  FirebaseChat
//
//  Created by Thomas Cacciatore on 7/2/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import Foundation
import MessageKit
import FirebaseDatabase

class ChatRoomController {
    
    let ref = Database.database().reference()
    
    
//    func fetchChatRooms() {
//
//        ref.child("chatRoom").observeSingleEvent(of: .value) { (snapshot) in
//            guard let chatRoomDictionaries = snapshot.value as? [String: [String: Any]] else { return }
//            var chatRooms = [ChatRoom] = []
//            for (_, value) in chatRoomDictionaries {
//                guard let chatroom = ChatRoom(dictionary: value) else { continue }
//                chatRooms.append(chatroom)
//            }
//        }
//
//
//    }
    
    func createChatRoom(with title: String, completion: @escaping () -> Void) {
        
        let room = ChatRoom(title: title)
        self.ref.child("chatRoom").setValue(["chatRoom" : room])
    }
    
    func createMessage() {
        
    }
    
    func fetchMessages() {
        
    }
    
}
