//
//  ChatController.swift
//  FirebaseChat
//
//  Created by Jon Bash on 2019-12-17.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation
import MessageKit
import FirebaseDatabase

class ChatController {
    private var databaseReference: DatabaseReference
    
    private let chatroomsKey = "chatrooms"
    private let messagesKey = "messages"
    
    var chatrooms = [ChatRoom]()
    private(set) var currentUser: Sender?
    
    private var chatroomObserver: UInt?
    
    init() {
        databaseReference = Database.database().reference()
    }
    
    func login(with user: Sender) {
        currentUser = user
    }
    
    func create(_ chatroom: ChatRoom, completion: @escaping (Error?) -> Void) {
        let room = databaseReference.child(chatroomsKey).child(chatroom.id)
        
        room.setValue(chatroom) { error, _ in
            completion(error)
        }
    }
    
    func create(
        _ message: Message,
        in chatroom: ChatRoom,
        completion: @escaping (Error?) -> Void)
    {
        let room = databaseReference.child(messagesKey).child(chatroom.id)
        
        room.setValue(message) { (error, database) in
            completion(error)
        }
    }
    
    func fetchChatrooms(completion: @escaping (Result<[ChatRoom], Error>) -> Void) {
        let chats = databaseReference.child(chatroomsKey)
        chats.observeSingleEvent(of: .value, with: { snapshot in
            guard let chatroomsByID = snapshot.value as? [String: ChatRoom] else {
                completion(.failure(NetworkError.badData))
                return
            }
            let chatrooms = Array<ChatRoom>(chatroomsByID.values)
            self.chatrooms = chatrooms
            
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
