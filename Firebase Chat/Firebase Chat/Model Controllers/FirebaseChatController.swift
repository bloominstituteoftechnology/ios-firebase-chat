//
//  FirebaseChatController.swift
//  Firebase Chat
//
//  Created by Lisa Sampson on 9/18/18.
//  Copyright © 2018 Lisa Sampson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseChatController {
    
    init(ref: DatabaseReference) {
        self.ref = ref
    }
    
    func createChatRoom(chatRoom: String, completion: @escaping () -> Void) {
        let chatRoom = ChatRoom(chatRoom: chatRoom)
        
    }
    
    func fetchChatRoom(completion: @escaping () -> Void) {
        
    }
    
    func createMessage(username: String, text: String, messageId: UUID, timestamp: Date, completion: @escaping () -> Void) {
        let message = ChatRoom.Message(username: username, timestamp: timestamp, messageId: messageId, text: text)
    }
    
    func fetchMessage(completion: @escaping () -> Void) {
        
    }
    
    var chatRooms = [ChatRoom]()
    var ref: DatabaseReference!
}
