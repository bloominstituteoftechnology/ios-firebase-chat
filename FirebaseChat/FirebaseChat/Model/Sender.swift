//
//  Sender.swift
//  FirebaseChat
//
//  Created by Morgan Smith on 8/7/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import Foundation
import MessageKit
import Firebase

struct Sender: SenderType {
    var senderId: String
    var displayName: String

    var dictionaryRepresentation: [String: String] {
        return ["id": senderId, "displayName": displayName]
    }

    init(senderId: String, displayName: String) {
        self.senderId = senderId
        self.displayName = displayName
    }

    init?(dictionary: [String: String]) {
        guard let id = dictionary["id"],
            let displayName = dictionary["displayName"] else { return nil }

        self.init(senderId: id, displayName: displayName)
    }
}
