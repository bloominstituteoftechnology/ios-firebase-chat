//
//  Message.swift
//  FirebaseChat
//
//  Created by Cody Morley on 6/16/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType, Codable {
    //MARK: - Types -
    enum CodingKeys: String, CodingKey {
        case sender
        case messageID
        case sentDate
        case kind
        case contents
    }
    
    //MARK: - Properties -
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind = .text(<#T##String#>)
    var contents: String
    
    
    //MARK: -Initializers -
    init(sender: User, messageID: String = UUID().uuidString, sentDate: Date = Date(), kind: MessageKind, contents: String) {
        self.sender = sender
        self.messageId = messageID
        self.sentDate = sentDate
        self.kind = kind
        self.contents = contents
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let sender = try container.decode(User.self, forKey: .sender)
        let messageID = try container.decode(String.self, forKey: .messageID)
        let sentDate = try container.decode(Date.self, forKey: .sentDate)
        let kind = try container.decode(MessageKind, forKey: .kind)
        let contents = try container.decode(String.self, forKey: .contents)
    }
    
    
    //MARK: - Methods -
    func encode(with encoder: Encoder) {
        
    }
}
