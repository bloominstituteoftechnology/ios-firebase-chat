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
    private let currentUserKey = "currentUser"
    
    private(set) var chatrooms = [ChatRoom]()
    private(set) var currentUser: Sender?
    
    private var observers = [String: UInt]()
    
    init() {
        databaseReference = Database.database().reference()
    }
    
    func attemptToLogIn(_ didSucced: (Bool) -> Void) {
        if let currentUserDictionary = UserDefaults.standard
            .value(forKey: currentUserKey) as? [String: String]
        {
            currentUser = Sender(dictionary: currentUserDictionary)
            didSucced(true)
        } else {
            didSucced(false)
        }
    }
    
    func login(with user: Sender) {
        currentUser = user
    }
    
    func create(_ chatroom: ChatRoom, completion: @escaping (Error?) -> Void) {
        let room = databaseReference.child(chatroomsKey).child(chatroom.id)
        
        room.setValue(chatroom.dictionaryRepresentation) { error, _ in
            completion(error)
        }
    }
    
    func create(
        _ message: Message,
        in chatroom: ChatRoom,
        completion: @escaping (Error?) -> Void)
    {
        let messageRef = databaseReference
            .child(messagesKey)
            .child(chatroom.id)
            .child(message.messageId)
        
        messageRef.setValue(message.dictionaryRepresentation) { error, _ in
            if let error = error {
                completion(error)
                return
            }
        }
        
        let updateDateAsInterval = message.sentDate.timeIntervalSinceReferenceDate
        let chatroomUpdatedRef = databaseReference
            .child(chatroomsKey)
            .child(chatroom.id)
            .child(ChatRoom.DictionaryKey.lastUpdated.rawValue)
        chatroomUpdatedRef.setValue(updateDateAsInterval) { error, database in
            completion(error)
        }
    }
    
    func fetchChatrooms(completion: @escaping (Result<[ChatRoom], Error>) -> Void) {
        let chats = databaseReference.child(chatroomsKey)
        chats.observeSingleEvent(of: .value, with: { snapshot in
            guard let chatroomsByID = snapshot.value as? [String: Any] else {
                completion(.failure(NetworkError.badData))
                return
            }
            var fetchedChatrooms = [ChatRoom]()
            for (_, chatroomRep) in chatroomsByID {
                guard
                    let chatroomRep = chatroomRep as? [String: Any],
                    let chatroom = ChatRoom(from: chatroomRep)
                    else { continue }
                fetchedChatrooms.append(chatroom)
            }
            fetchedChatrooms.sort { $0.lastUpdated > $1.lastUpdated }
            
            self.chatrooms = fetchedChatrooms
            
            completion(.success(fetchedChatrooms))
        }) { error in
            completion(.failure(error))
        }
    }
    
    func observeMessages(
        for chatroom: ChatRoom,
        callback: @escaping (Result<[Message], Error>) -> Void)
    {
        if observers[chatroom.id] != nil { return }
        
        let roomRef = databaseReference.child(messagesKey).child(chatroom.id)
        self.observers[chatroom.id] = roomRef.observe(.value, with: { snapshot in
            let messagesByID = snapshot.value as? [String: Any] ?? [:]
            
            var messages = [Message]()
            for (_, messageRep) in messagesByID {
                guard
                    let messageRep = messageRep as? [String: Any],
                    let message = Message(from: messageRep)
                    else { continue }
                messages.append(message)
            }
            
            callback(.success(messages))
        }) { error in
            callback(.failure(error))
        }
    }
    
    func stopObserving() {
        for (id, handle) in observers {
            databaseReference.child(messagesKey).child(id)
                .removeObserver(withHandle: handle)
            observers[id] = nil
        }
    }
}
