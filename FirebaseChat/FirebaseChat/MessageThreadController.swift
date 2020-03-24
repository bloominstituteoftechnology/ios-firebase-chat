//
//  MessageThreadController.swift
//  FirebaseChat
//
//  Created by Ufuk Türközü on 24.03.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import Firebase
import MessageKit

class MessageThreadController {
    
    var messageThreads: [MessageThread] = []
    var currentUser: SenderType?
    var ref: DatabaseReference = Database.database().reference()
    
    func fetchMessageThreads(completion: @escaping() -> Void) {
        
        
        
    }
    
    func createMessageThread(completion: @escaping() -> Void) {
        
        
    
    }
    
    func fetchMessages(completion: @escaping() -> Void) {
        
        
    
    }
    
    func createMessage(completion: @escaping() -> Void) {
        
        
    
    }
    
}
