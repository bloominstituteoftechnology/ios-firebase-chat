//
//  MessageController.swift
//  FirebaseChat
//
//  Created by Shawn Gee on 4/21/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation
import FirebaseDatabase
import MessageKit

class MessageController {
    // MARK: - CRUD
    
    private(set) var messages: [Message] = []
    
    func createMessage(with text: String, from sender: User) {
        let message = Message(messageText: text, messageId: UUID().uuidString, sentDate: Date(), sender: sender)
        messagesRef.childByAutoId().setValue(message)
    }
    
    // MARK: - Private Properties
    
    private let databaseRef: DatabaseReference = Database.database().reference()
    private let messagesRef: DatabaseReference
    
    // MARK: - Init
    
    init(chatRoom: ChatRoom) {
        messagesRef = databaseRef.child("messages").ref.child(chatRoom.id)
        setUpObservers()
    }
    
    // MARK: - Private Methods
    
    func setUpObservers() {
        let messageQuery = messagesRef.queryOrderedByKey()
        messageQuery.observe(.value) { (snapshot) in
            guard let messageDicts = snapshot.value as? [String: [String: Any]] else { return }
            self.messages = messageDicts.values.compactMap { Message(with: $0) }
        }
    }
}
