//
//  Message.swift
//  FirebaseChat
//
//  Created by Elizabeth Thomas on 8/10/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import Foundation
import MessageKit
import Firebase

struct Message {
    let id: String
    let text: String
    let date: Date
    
    init(id: String = UUID().uuidString,
         text: String,
         date: Date = Date()) {
        self.id = id
        self.text = text
        self.date = date
    }
    
    init?(id: String, dict: [String: Any]) {
        guard let text = dict["text"] as? String else { return nil }
        
        self.id = id
        self.text = text
        self.date = Date()
    }
}
