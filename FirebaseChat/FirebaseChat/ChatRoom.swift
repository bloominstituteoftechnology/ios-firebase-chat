//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Jorge Alvarez on 2/25/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import Firebase

struct ChatRoom {
    var ref: DatabaseReference!
    
    init() {
        self.ref = Database.database().reference()
    }
}
