//
//  Message.swift
//  Chat
//
//  Created by Chris Dobek on 5/20/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation

struct Message {
    
    let sender: String
    let message: String
    let id: String
    
    init(sender: String, message: String, id: String) {
        self.sender = sender
        self.message = message
        self.id = id
    }
    
}
