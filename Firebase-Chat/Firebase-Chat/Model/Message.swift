//
//  Message.swift
//  Firebase-Chat
//
//  Created by Marlon Raskin on 9/17/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation

struct Message: Codable, Equatable {
	let text: String
	let sender: String
	let timestamp: Date
	let senderId: String
	let messageId: UUID
}
