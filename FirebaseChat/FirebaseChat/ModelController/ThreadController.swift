//
//  ThreadController.swift
//  FirebaseChat
//
//  Created by Clayton Watkins on 8/12/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation
import MessageKit
import Firebase

class ThreadController {
    
    // MARK: - Properties
    var threads: [Thread] = []
    var threadRef = Database.database().reference().child("Threads")
    
    // MARK: - Functions
    func createThread(title: String, completion: @escaping () -> Void) {
        let thread = Thread(threadTitle: title)
        threads.append(thread)
        self.threadRef.child("\(title)").setValue(thread.dictionary(thread: thread))
        completion()
    }
//    
//    func createMessage(in thread: Thread, text: String, completion: @escaping () -> Void) {
//        let message = Message(messageText)
//        thread.messages.append(message)
//        self.ref.child("threads/messages/messageText").setValue(text)
//    }
    
}
