//
//  Message.swift
//  Firebase Chat
//
//  Created by Vici Shaweddy on 12/4/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import Foundation
import MessageKit
import FirebaseDatabase

struct Message: Codable, Equatable {
    let identifier: String?
    let message: String?
    
    init(message: String) {
        self.identifier = UUID().uuidString
        self.message = message
    }
    
    init(snapshot: DataSnapshot) {
        let values = snapshot.value as? [String: AnyObject]
        self.identifier = values?["identifier"] as? String ?? nil
        self.message = values?["message"] as? String ?? nil
    }
}
 
 
