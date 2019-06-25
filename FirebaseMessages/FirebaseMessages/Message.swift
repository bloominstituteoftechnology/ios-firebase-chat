//
//  Message.swift
//  FirebaseMessages
//
//  Created by Jonathan Ferrer on 6/25/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation
import MessageKit
import Firebase

struct Message: MessageType {

    var sender: SenderType

    var messageId: String

    var sentDate: Date

    var kind: MessageKind

    


}
