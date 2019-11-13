//
//  Sender+UserDefaults.swift
//  Firebase Chat
//
//  Created by macbook on 11/13/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import MessageKit

extension Sender {
    
    //Conver a sender to a dictionary to be saved to User Defaults
    
    var dictionaryRepresentation : [ String : String ] {
        return ["id" : senderId, //25326346346346-346346245253
                "displayName": displayName] //Sender Name
    }
    
    // Convert a dictionary back to a sender object to be used by the rest of the app
    
    init?(dictionary: [ String : String]) {
        guard let id = dictionary["id"],
            let displayName = dictionary["displayName"] else { return nil }
        
        self.init(senderId: id, displayName: displayName)
    }
}
