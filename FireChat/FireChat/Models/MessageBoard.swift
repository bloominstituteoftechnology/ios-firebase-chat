//
//  MessageBoard.swift
//  FireChat
//
//  Created by Ezra Black on 4/25/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation

struct MessageBoard {
    let id: String
    let boardName: String
    var messages: [Message]
    
    init(boardName: String, id: String = UUID().uuidString, messages: [Message] = []) {
        self.id = id
        self.boardName = boardName
        self.messages = messages
    }
}
