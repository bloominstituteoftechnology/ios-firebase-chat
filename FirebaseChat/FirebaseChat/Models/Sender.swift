//
//  Sender.swift
//  FirebaseChat
//
//  Created by Christopher Aronson on 6/18/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import MessageKit

struct Sender: SenderType {
    
    var senderId: String
    var displayName: String

    init?(data: [String : Any]) {
        guard let displayName = data["displayName"] as? String,
        let senderId = data["id"] as? String
        else { return nil }

        self.displayName = displayName
        self.senderId = senderId
    }

    init(displayName: String, senderId: String) {
        self.displayName = displayName
        self.senderId = senderId
        
    }
}
