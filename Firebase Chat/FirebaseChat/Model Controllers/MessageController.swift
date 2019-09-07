//
//  MessageController.swift
//  FirebaseChat
//
//  Created by Spencer Curtis on 9/18/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import MessageKit
import FirebaseDatabase

class MessageController {
    private let messagesRef = Database.database().reference().child("messages")
    
    func createMessageIn(room: ChatRoom, with sender: Sender, text: String) {
        let destinationRef = messagesRef.child(room.identifier).childByAutoId()
        guard let messageId = destinationRef.key else { return }
        let message = Message(sender: sender, messageId: messageId, text: text)
        destinationRef.setValue(message.dictionaryRepresentation)
    }
    
    func fetchMessagesFor(room: ChatRoom) {
        let roomMessagesRef = messagesRef.child(room.identifier)
        roomMessagesRef.observe(.value) { (snapshot) in
            guard let messageDictionaries = snapshot.value as? [String : [String : Any]] else { return }
            let messages = messageDictionaries.compactMap({ Message(dictionary: $0.value) }).sorted(by: { $0.sentDate < $1.sentDate })

            room.messages = messages            
        }
    }
}
