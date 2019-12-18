//
//  Sender+UserDefaults.swift
//  FirebaseChat
//
//  Created by Jon Bash on 12/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import MessageKit

extension Sender {
    var dictionaryRepresentation: [String: String] {
        return ["id": senderId, "displayName": displayName]
    }
    
    init?(dictionary: [String: String]) {
        guard
            let id = dictionary["id"],
            let displayName = dictionary["displayName"]
            else { return nil }
        
        self.init(senderId: id, displayName: displayName)
    }
}
