//
//  Sender+UserDefaults.swift
//  FirebaseChat
//
//  Created by Thomas Cacciatore on 7/2/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import Foundation

import MessageKit

extension Sender {
    
    // Convert a sender to a dictionary to be saved to UD
    
    var dictionaryRepresentation: [String: String] {
        return ["id": senderId, // 293082-90384-019482748293-3023
            "displayName": displayName] // Spencer
    }
    
    // Convert a dictionary back to a Sender object to be used by the rest of the app.
    
    init?(dictionary: [String: String]) {
        
        guard let id = dictionary["id"],
            let displayName = dictionary["displayName"] else { return nil }
        
        self.init(senderId: id, displayName: displayName)
    }
}
