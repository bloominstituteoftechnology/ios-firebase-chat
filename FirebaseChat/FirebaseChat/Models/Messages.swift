//
//  Messages.swift
//  FirebaseChat
//
//  Created by Christopher Aronson on 6/18/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation

struct Message: Codable {
    let sender: User
    let timestamp: Date
    let message: String
}
