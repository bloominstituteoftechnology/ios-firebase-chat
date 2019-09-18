//
//  Group.swift
//  LambdaChat
//
//  Created by Jeffrey Santana on 9/17/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

struct Group {
	let id: UUID
	let title: String
	let timestamp: Date
	let messages: [Message]?
	
	init(id: UUID = UUID(), title: String, timestamp: Date = Date(), messages: [Message]? = nil) {
		self.id = id
		self.title = title
		self.timestamp = timestamp
		self.messages = messages
	}
}
