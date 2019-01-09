//
//  FirebaseChat.swift
//  Firebase-Chat
//
//  Created by Yvette Zhukovsky on 1/8/19.
//  Copyright © 2019 Yvette Zhukovsky. All rights reserved.
//

import Foundation
import MessageKit
import FirebaseDatabase


struct Chat {
    
    let name: String?
    let id: String?
    
    
    
    init(dict:[String: Any?] ) {
        
        self.name = dict["name"] as? String
        self.id = dict["id"] as? String
        
    }
}

