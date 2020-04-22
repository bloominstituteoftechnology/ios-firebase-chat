//
//  Sender+Codable.swift
//  FirebaseChat
//
//  Created by Christopher Devito on 4/21/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import Foundation
import MessageKit

extension Sender: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let senderID = try container.decode(String.self, forKey: .senderID)
        let displayName = try container.decode(String.self, forKey: .displayName)
        self.init(senderId: senderID, displayName: displayName)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(senderId, forKey: .senderID)
        try container.encode(displayName, forKey: .displayName)
    }
    
    enum CodingKeys: String, Codable, CodingKey {
        case senderID
        case displayName
    }
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

extension Sender {
    var dictionaryRepresentation: [String : String] {
        return ["id" : senderId,
                "displayName" : displayName]
    }
    
    init?(dictionary: [String : String]) {
        guard let id = dictionary["id"], let displayName = dictionary["displayName"] else {
            return nil
        }
        
        self.init(senderId: id, displayName: displayName)
    }
}
