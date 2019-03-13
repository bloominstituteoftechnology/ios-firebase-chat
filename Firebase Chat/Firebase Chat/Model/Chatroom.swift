//
//  Chatroom.swift
//  Firebase Chat
//
//  Created by Angel Buenrostro on 3/13/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation
import MessageKit

class Chatroom: Codable {
    var title: String
    var messages: [Message]
}
