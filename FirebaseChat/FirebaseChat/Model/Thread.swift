//
//  Thread.swift
//  FirebaseChat
//
//  Created by Clayton Watkins on 8/12/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation

class Thread {
    
    let threadTitle: String
    var messages: [Message]
    let id: String
    
    
    init(threadTitle: String, messages: [Message] = [], id: String = UUID().uuidString) {
        self.threadTitle = threadTitle
        self.messages = messages
        self.id = id
    }
    
    func dictionary(thread: Thread) -> [String : Any] {
        let threadDictionary = [
            "Thread title" : thread.threadTitle,
            "Messages" : thread.messages,
            "ID" : thread.id
            ] as [String : Any]
        return threadDictionary
    }
    
}
