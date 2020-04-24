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

extension NSNotification.Name {
    static let messagesUpdated = NSNotification.Name("MessagesUpdated")
}

class MessageController {
    // MARK: - Public Properties
    
    var currentUser: User?
    
    // MARK: - CRUD
    
    private(set) var messages: [Message] = [] {
        didSet {
            NotificationCenter.default.post(name: .messagesUpdated, object: self)
        }
    }
    
    @discardableResult
    func createMessage(with text: String, from sender: User) -> Message {
        let message = Message(messageText: text, messageId: UUID().uuidString, sentDate: Date(), sender: sender)
        messagesRef.childByAutoId().setValue(message.dictionaryRepresentation)
        return message
    }
    
    // MARK: - Private Properties
    
    private let databaseRef: DatabaseReference = Database.database().reference()
    private let messagesRef: DatabaseReference
    
    // MARK: - Init
    
    init(chatRoom: ChatRoom) {
        messagesRef = databaseRef.child("messages").ref.child(chatRoom.id)
        setUpObservers()
        // TODO: Remove observers
    }
    
    // MARK: - Private Methods
    
    func setUpObservers() {
        let messageQuery = messagesRef.queryOrderedByKey()
        
        messageQuery.observe(.value) { (snapshot) in
            var messages = [Message]()
            for child in snapshot.children {
                guard
                    let childSnapshot = child as? DataSnapshot,
                    let messageDict = childSnapshot.value as? [String: Any],
                    let message = Message(with: messageDict) else { continue }
                
                messages.append(message)
            }
            self.messages = messages
        }
    }
}


