//
//  Model.swift
//  Firebase
//
//  Created by Alex Thompson on 2/15/20.
//  Copyright © 2020 Lambda_School_Loaner_213. All rights reserved.
//

import Foundation

struct Chat: Codable, Equatable {
    let identifier: String
    let messages: [Message]
    
    init(identifier: String = UUID().uuidString, messages: [Message] = []) {
        self.identifier = identifier
        self.messages = messages
    }
    
    init(dictionary: [String: AnyObject]) {
        self.identifier = dictionary.keys.first ?? ""
        
        var messages = [Message]()
        for message in dictionary.values {
            let message = Message(dictionary: message as! [String: AnyObject])
            messages.append(message)
        }
        self.messages = messages
    }
}
