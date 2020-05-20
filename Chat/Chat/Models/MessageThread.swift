//
//  MessageThread.swift
//  Chat
//
//  Created by Chris Dobek on 5/20/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation

struct MessageThread {
    
    let id: String
    let threadName: String
    var messages: [Message]
    
    init(id: String, threadName: String, messages: [Message]) {
        self.id = id
        self.threadName = threadName
        self.messages = messages
    }
}
