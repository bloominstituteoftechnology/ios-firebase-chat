//
//  Chatroom.swift
//  Chat
//
//  Created by Nick Nguyen on 3/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation

struct Chatroom: Codable {
    
    let id: String
    let name: String
    let roomPurpose: String 
   
    
    init(name: String,roomPurpose: String, id: String = UUID().uuidString) {
        self.name = name
        self.roomPurpose = roomPurpose
        self.id = id
    }
    enum CodingKeys: String, CodingKey {
        case name
        case roomPurpose
        case id
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(roomPurpose, forKey: .roomPurpose)
        
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try container.decode(String.self, forKey: .name)
        let roomPurpose = try container.decode(String.self, forKey: .roomPurpose)
        let id = try container.decode(String.self, forKey: .id)
        
        
        self.init(name: name, roomPurpose: roomPurpose, id : id )
    }
}
