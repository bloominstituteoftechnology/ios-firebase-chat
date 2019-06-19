//
//  Sender.swift
//  FirebaseChat
//
//  Created by Christopher Aronson on 6/18/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import MessageKit

struct Sender: SenderType, Codable {
    
    var senderId: String
    var displayName: String

    init(displayName: String, senderId: String) {
        self.displayName = displayName
        self.senderId = senderId
        
    }
}
