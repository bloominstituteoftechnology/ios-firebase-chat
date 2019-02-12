//
//  FirebaseChatController.swift
//  Firebase Chat
//
//  Created by Lisa Sampson on 9/18/18.
//  Copyright © 2018 Lisa Sampson. All rights reserved.
//

import Foundation
import FirebaseDatabase
import MessageKit

class FirebaseChatController {
    
    init(ref: DatabaseReference) {
        self.ref = ref
    }
    
    func createChatRoom(chatRoom: String) {
        let chatRoom = ChatRoom(chatRoom: chatRoom)
        self.ref.child("chatRoom").child(chatRoom.id).setValue(chatRoom.toDictionary())
        chatRooms.append(chatRoom)
    }
    
    func createMessage(chatRoom: ChatRoom, username: String, text: String, messageId: String = UUID().uuidString, timestamp: Date = Date()) {
        guard let index = chatRooms.index(of: chatRoom) else { return }

        let message = ChatRoom.Message(username: username, timestamp: timestamp, messageId: messageId, text: text)
        
        var scratchChat = chatRoom
        scratchChat.messages.append(message)
        
        self.ref.child("chatRoom").child(scratchChat.id).setValue(scratchChat.toDictionary())
        
        chatRooms[index] = scratchChat
    }
    
    func fetchChatRoom(completion: @escaping () -> Void) {
        ref.child("chatRoom").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: [String: Any]] else { return }
            let chatRooms = value.values.map { chatRoomDictionary in ChatRoom(chatRoom: chatRoomDictionary)}
            self.chatRooms = chatRooms
            completion()
        }
    }
    
    var chatRooms = [ChatRoom]()
    var ref: DatabaseReference!
    var currentUser: Sender?
}
