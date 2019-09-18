//
//  Chat.swift
//  Firebase-Chat
//
//  Created by Marlon Raskin on 9/17/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import Firebase

var dateFormatter: DateFormatter {
	let formatter = DateFormatter()
	formatter.dateStyle = .long
	formatter.timeStyle = .long
	return formatter
}

struct ChatRoom {
	let chatRoomId: UUID
	let name: String
	let timestamp: Date
	let messages: [Message]?

	init(name: String, chatRoomId: UUID = UUID(), messages: [Message]? = nil, timestamp: Date = Date()) {
		self.name = name
		self.chatRoomId = chatRoomId
		self.messages = messages
		self.timestamp = timestamp
	}

	init?(snapshot: DataSnapshot) {
		guard
			let value = snapshot.value as? [String: AnyObject],
			let name = value["name"] as? String,
			let timestamp = value["timestamp"] as? String,
			let uuidFromStr = UUID(uuidString: snapshot.key),
			let dateFromStr = dateFormatter.date(from: timestamp) else {
			return nil
		}

		self.chatRoomId = uuidFromStr
		self.name = name
		self.timestamp = dateFromStr
		self.messages = nil
	}

	func toDictionary() -> Any {
		return [
			"chatRoomId": chatRoomId.uuidString,
			"name": name,
			"timestamp": dateFormatter.string(from: timestamp)
		]
	}
}


