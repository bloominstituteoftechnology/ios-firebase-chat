//
//  Sender+UserDefaults.swift
//  FirebaseChat
//
//  Created by Jake Connerly on 10/15/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import MessageKit

extension Sender {
    
    // Convert a sender to a dictionary to be saved to User Defaults
    
    var dictionaryRepresentation: [String : String] {
        return ["id": senderId, // 293082-90384-01021312041
            "displayName": displayName] // Johnny
    }
    
    // Convert a dictionary back to a Sender object to be used by the rest of the app
    
    init?(dictionary: [String: String]) {
        guard let id = dictionary["id"],
            let displayName = dictionary["displayName"] else { return nil }
        self.init(senderId: id, displayName: displayName)
    }
}
