//
//  User.swift
//  FirebaseChat
//
//  Created by Cody Morley on 6/16/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import MessageKit

struct User: SenderType, Codable {
    //MARK: - Types -
    let uniqueID: UUID
    var senderId: String {
        return uniqueID.uuidString
    }
    var displayName: String
    
    init(displayName: String, uniqueID: UUID = UUID()) {
        self.displayName = displayName
        self.uniqueID = uniqueID
    }
}
