//
//  User.swift
//  FirebaseMessages
//
//  Created by Jonathan Ferrer on 6/25/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation
import MessageKit

struct User: SenderType {
    var id: String
    var senderId: String {
        return id
    }
    var displayName: String
}
