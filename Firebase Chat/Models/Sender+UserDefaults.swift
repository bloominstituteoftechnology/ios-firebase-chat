//
//  Sender+UserDefaults.swift
//  Firebase Chat
//
//  Created by Wyatt Harrell on 4/21/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import Foundation
import MessageKit

extension Sender {
    var dictionaryRepresentation: [String : String] {
        return ["id": senderId, "displayName": displayName]
    }
    
    init?(dictionary: [String : String]) {
        guard let id = dictionary["id"], let displayName = dictionary["displayName"] else {
            return nil
        }
        
        self.init(senderId: id, displayName: displayName)
    }
}
