//
//  UserDefaults+Sender.swift
//  Chat
//
//  Created by Kat Milton on 8/20/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation
import MessageKit

extension UserDefaults {
    var currentSender: Sender? {
        get {
            guard let senderID = string(forKey: "senderId"),
                let displayName = string(forKey: "displayName") else {
                    return nil
            }
            return Sender(senderId: senderID, displayName: displayName)
        }
        set {
            set(newValue?.senderId, forKey: "senderId")
            set(newValue?.displayName, forKey: "displayName")
        }
        
    }
}

extension Sender {
    
    var dictionaryRepresentation: [String: String] {
        return ["id": senderId,
            "displayName": displayName]
    }
    
    init?(dictionary: [String: String]) {
        
        guard let id = dictionary["id"],
            let displayName = dictionary["displayName"] else { return nil }
        
        self.init(senderId: id, displayName: displayName)
    }
}
