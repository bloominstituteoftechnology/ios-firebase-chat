//
//  Chatroom.swift
//  iOS Firebase Chat
//
//  Created by Dillon McElhinney on 10/23/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation

class Chatroom: Equatable, Decodable {
    
    // MARK: - Properties
    let title: String
    let identifier: String
    let timestampUpdated: Date
    
    enum CodingKeys: String, CodingKey {
        case title
        case identifier
        case timestampUpdated
    }
    
    // MARK: - Initializers
    init(title: String, messages: [Message] = [], identifier: String = UUID().uuidString, timestampUpdated: Date = Date()) {
        self.title = title
        self.identifier = identifier
        self.timestampUpdated = timestampUpdated
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: .title)
        let identifier = try container.decode(String.self, forKey: .identifier)
        let timestampUpdated = try container.decodeIfPresent(String.self, forKey: .timestampUpdated)
        
        self.title = title
        self.identifier = identifier
        self.timestampUpdated =  ISO8601DateFormatter().date(from: timestampUpdated ?? "") ?? Date()
    }
    
    // MARK: - Equatable
    static func ==(lhs: Chatroom, rhs: Chatroom) -> Bool {
        return lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier
    }
    
}
