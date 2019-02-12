//
//  Message.swift
//  ios-firebase-chat
//
//  Created by Benjamin Hakes on 2/12/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation

struct Message {
    let title: String?
    let body: String?
    let timestamp: Date = Date()
}
