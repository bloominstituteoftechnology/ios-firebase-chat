//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Simon Elhoej Steinmejer on 18/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation

struct ChatRoom
{
    let name: String?
    let id: String?
    
    init(dictionary: [String: Any])
    {
        self.name = dictionary["name"] as? String
        self.id = dictionary["id"] as? String
    }
}
