//
//  ChatRoomController.swift
//  FirebaseChat
//
//  Created by Bradley Yin on 9/17/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChatRoomController {
    
    var chatRooms: [ChatRoom] = []
    
    var currentUser: Sender?
    
    let databaseRef = Database.database().reference()
    
    func createChatRoom(title: String, completion: @escaping () -> Void) {
        let chatRoom = ChatRoom(title: title, messages: [], identifier: UUID().uuidString)
        databaseRef.child(chatRoom.identifier).setValue(chatRoom.toDict())
        completion()
    }
    
    func fetchChatRoom(completion: @escaping () -> Void) {
        databaseRef.observeSingleEvent(of: .childAdded) { (snapshot) in
            guard let snapshotValue = snapshot.value as? Dictionary<String, String> else { fatalError("cant cast to dict")}
            let chatRoom = ChatRoom(title: snapshotValue["title"]!, messages: [], identifier: snapshotValue["identifier"]!)
            self.chatRooms.append(chatRoom)
            print(self.chatRooms)
            completion()
         
        }
    }
    
    func createMessage(chatRoom: ChatRoom, message: Message, completion: @escaping () -> Void) {
    databaseRef.child(chatRoom.identifier).child("messages").child(message.messageId).setValue(message.toDict())
        
        completion()
    }
}
