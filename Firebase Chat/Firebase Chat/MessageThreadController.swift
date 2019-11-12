//
//  MessageThreadController.swift
//  Firebase Chat
//
//  Created by Isaac Lyons on 11/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MessageThreadController {
    var ref = Database.database().reference()
    var threads: [MessageThread] = []
    
    func createMessageThread(title: String) {
        let thread = MessageThread(title: title)
        
        threads.append(thread)
        ref.child(thread.identifier).setValue(thread.dictionaryRepresentation)
    }
    
    func createMessage(in thread: MessageThread, withText text: String, fromSender sender: Sender) {
        
        let message = MessageThread.Message(text: text, sender: sender)
        thread.messages.append(message)
        
        ref.child(thread.identifier).setValue(thread.dictionaryRepresentation)
    }
    
    func fetchThreads(completion: @escaping () -> Void) {
        threads = []
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let values = snapshot.value as? NSDictionary else { completion(); return }
            for value in values {
                guard let threadDictionary = value.value as? NSDictionary,
                    let thread = MessageThread(from: threadDictionary) else { continue }
                self.threads.append(thread)
            }
            completion()
        }
    }
}
