//
//  Message.swift
//  ios-firebase-chat
//
//  Created by Benjamin Hakes on 2/12/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation

struct Message {
    let title: NSString?
    let body: NSString?
    let timestamp: NSNumber = NSNumber(floatLiteral: Date().timeIntervalSince1970)
    let messageID: NSString = UUID().uuidString as NSString
    
}
