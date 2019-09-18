//
//  Chat.swift
//  Firebase-Chat
//
//  Created by Marlon Raskin on 9/17/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation

struct ChatRoom: Codable, Equatable {
	let chatRoomId: UUID
	let name: String
	let timestamp: Date
	let messages: [Message]

	init(name: String, chatRoomId: UUID = UUID(), messages: [Message] = [], timestamp: Date = Date()) {
		self.name = name
		self.chatRoomId = chatRoomId
		self.messages = messages
		self.timestamp = timestamp
	}

	func toDictionary() -> Any {
		
		var dateFormatter: DateFormatter {
			let formatter = DateFormatter()
			formatter.dateFormat = "MM-dd-yyy'T'HH:mm"
			return formatter
		}

		return [
			"chatRoomId": chatRoomId.uuidString,
			"name": name,
			"timestamp": dateFormatter.string(from: timestamp)
		]
	}
}


