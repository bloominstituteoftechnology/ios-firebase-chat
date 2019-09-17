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
    
    func createChatRoom(title: String) {
        let chatRoom = ChatRoom(title: title, messages: [], identifier: UUID().uuidString)
        databaseRef.child(chatRoom.identifier).setValue(chatRoom.toDict())
    }
    
    func fetchChatRoom() {
        databaseRef.observeSingleEvent(of: .childAdded) { (snapshot) in
            guard let snapshotValue = snapshot.value as? Dictionary<String, String> else { fatalError("cant cast to dict")}
            let chatRoom = ChatRoom(title: snapshotValue["title"]! as! String, messages: [], identifier: snapshotValue["identifier"] as! String)
            self.chatRooms.append(chatRoom)
            print(self.chatRooms)
         
        }
    }
    
    func createMessage(chatRoom: ChatRoom, message: Message) {
        databaseRef.child(chatRoom.identifier).child(message.messageId).setValue(message.toDict())
    }
}
