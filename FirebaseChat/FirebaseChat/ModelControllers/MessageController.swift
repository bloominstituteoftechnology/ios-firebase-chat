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
    
    private(set) var messages: [Message] = [] { didSet { messagesDidSet?() }}
    
    var messagesDidSet: (() -> Void)?
    
    func createMessage(with text: String, from sender: User) {
        let message = Message(messageText: text, messageId: UUID().uuidString, sentDate: Date(), sender: sender)
        messagesRef.childByAutoId().setValue(message.dictionaryRepresentation)
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

// MARK: - Messages Data Source

extension MessageController: MessagesDataSource {
    func currentSender() -> SenderType {
        return User(id: "123", displayName: "Shawn")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.row]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}
