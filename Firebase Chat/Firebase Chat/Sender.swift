//
//  Sender.swift
//  Firebase Chat
//
//  Created by Isaac Lyons on 11/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
    
    var dictionaryRepresentation: [String: String] {
        return ["id": senderId, "displayName": displayName]
    }
}
