//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Christopher Devito on 4/21/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import Foundation
import MessageKit

struct ChatRoom: Codable {
    var id: String
    var name: String
    var users: [Sender]
    
    init(id: String = UUID().uuidString, name: String, users: [Sender] =  []) {
        self.id = id
        self.name = name
        self.users = users
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        
        let users = try container.decode([Sender].self, forKey: .users)
        self.init(id: id, name: name, users: users)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(users, forKey: .users)
    }
    
    var dictionaryRepresentation: [String : [Any]] {
        return ["id" : [id],
                "name" : [name],
                "users" : users]
    }
    
    init?(dictionary: [String : [Any]]) {
        guard let id = dictionary["id"], let name = dictionary["name"], let users = dictionary["users"] else {
            return nil
        }
        
        self.init(id: id.first as! String, name: name.first as! String, users: users as! [Sender])
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case users
    }
}
