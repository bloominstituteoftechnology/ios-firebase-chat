//
//  Message.swift
//  FireChat
//
//  Created by Ezra Black on 4/25/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation

struct Message {
    let sender: String
    let message: String
    let id: String
    
    init(sender: String,
         id: String = UUID().uuidString,
         message: String) {
        self.id = id
        self.sender = sender
        self.message = message
    }
}
