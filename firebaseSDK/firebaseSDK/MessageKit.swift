//
//  MessageKit.swift
//  firebaseSDK
//
//  Created by Karen Rodriguez on 4/21/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import Foundation
import MessageKit

struct UserPost: MessageType {
    
    var sender: SenderType
    
    var messageId: String = UUID().uuidString
    
    var sentDate: Date
    
    var kind: MessageKind
    
}

class User: SenderType {
    var senderId: String
    
    var displayName: String
    
    init (senderId: String = UUID().uuidString, displayName: String) {
        self.senderId = senderId
        self.displayName = displayName
    }
}

