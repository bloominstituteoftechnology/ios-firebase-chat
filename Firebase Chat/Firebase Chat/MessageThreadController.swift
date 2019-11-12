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
    
    func createMessageThread(title: String) {
        let thread = MessageThread(title: title)
        
        ref.child(thread.identifier).setValue(thread.dictionaryRepresentation)
    }
    
    func createMessage(in messageThread: MessageThread, withText text: String, fromSender sender: Sender) {
        
        let message = MessageThread.Message(text: text, sender: sender)
        
        //ref.chil
    }
}
