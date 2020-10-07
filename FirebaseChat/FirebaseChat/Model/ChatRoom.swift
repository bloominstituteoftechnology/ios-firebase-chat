//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Rob Vance on 10/2/20.
//

import Foundation

struct ChatRoom {
    let id: String
    let name: String
    
    init(id: String = UUID().uuidString, name: String) {
        self.id = id
        self.name = name
    }
    
    init?(id: String, dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String else { return nil }
        
        self.id = id
        self.name = name
    }
}
