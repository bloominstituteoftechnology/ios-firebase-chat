//
//  Chat.swift
//  Firebase Chat
//
//  Created by Vici Shaweddy on 12/4/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import Foundation

struct Chat: Codable, Equatable {
    let identifier: String
    let sender: String
    let receiver: String
}
