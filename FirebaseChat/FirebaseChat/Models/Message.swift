//
//  Message.swift
//  FirebaseChat
//
//  Created by Ciara Beitel on 10/15/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import Foundation

struct Message {
    var id: UUID
    var sender: String
    var text: String
    var timeStamp: Date
}
