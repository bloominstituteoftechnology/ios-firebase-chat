//
//  ChatController.swift
//  FirebaseChat
//
//  Created by Jon Bash on 2019-12-17.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChatController {
    var databaseReference: DatabaseReference
    
    let chatroomsKey = "chatrooms"
    let messagesKey = "messages"
    
    var chatrooms = [ChatRoom]()
    
    var chatroomObserver: UInt?
    
    init() {
        databaseReference = Database.database().reference()
    }
    
    func create(_ chatroom: ChatRoom) {
        databaseReference.child(chatroomsKey).child(chatroom.id)
            .setValue(chatroom)
    }
    
    func create(
        _ message: Message,
        in chatroom: ChatRoom,
        completion: (Error?) -> Void)
    {
        databaseReference.child(messagesKey).child(chatroom.id)
            .setValue(message)
    }
    
    func fetchChatrooms(completion: @escaping (Result<[ChatRoom], Error>) -> Void) {
        let chats = databaseReference.child(chatroomsKey)
        chats.observeSingleEvent(of: .value, with: { snapshot in
            guard let chatroomsByID = snapshot.value as? [String: ChatRoom] else {
                completion(.failure(NetworkError.badData))
                return
            }
            let chatrooms = Array<ChatRoom>(chatroomsByID.values)
            
            completion(.success(chatrooms))
        }) { error in
            completion(.failure(error))
        }
    }
    
    func observeMessages(
        for chatroom: ChatRoom,
        callback: @escaping (Result<[Message], Error>) -> Void)
    {
        let roomHandle = databaseReference.child(messagesKey).child(chatroom.id)
        self.chatroomObserver = roomHandle.observe(.value, with: { snapshot in
            let messagesByID = snapshot.value as? [String: Message] ?? [:]
            let messages = Array<Message>(messagesByID.values)
            
            callback(.success(messages))
        }) { error in
            callback(.failure(error))
        }
    }
}
