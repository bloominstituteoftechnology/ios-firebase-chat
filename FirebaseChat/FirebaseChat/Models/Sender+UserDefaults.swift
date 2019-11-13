//
//  Sender+UserDefaults.swift
//  FirebaseChat
//
//  Created by Gi Pyo Kim on 11/12/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation
import MessageKit

extension Sender {
    var dictionaryRepresentation: [String: String] {
        return ["senderId": senderId, "displayName": displayName]
    }
    
    init?(dictionary: [String: String]) {
        guard let senderId = dictionary["senderId"], let displayName = dictionary["displayName"] else { return nil }
        self.init(senderId: senderId, displayName: displayName)
    }
}
