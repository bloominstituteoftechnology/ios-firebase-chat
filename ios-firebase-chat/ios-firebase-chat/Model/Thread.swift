//
//  Thread.swift
//  ios-firebase-chat
//
//  Created by Benjamin Hakes on 2/12/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation

struct Thread {
    let title: String
    let messages: [Message?] = []
    
    init(title: String) {
        self.title = title
    }
}
