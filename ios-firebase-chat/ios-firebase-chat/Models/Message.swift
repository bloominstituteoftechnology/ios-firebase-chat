//
//  Message.swift
//  ios-firebase-chat
//
//  Created by Austin Cole on 2/12/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation

struct Message: Decodable {
    let identifier: String
    let title: String
    let messageBody: String
    let author: String
    let timestamp: Date
}
