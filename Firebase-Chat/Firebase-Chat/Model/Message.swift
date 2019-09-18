//
//  Message.swift
//  Firebase-Chat
//
//  Created by Marlon Raskin on 9/17/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import Firebase
import MessageKit

struct Message {
	let text: String
	let user: Sender
	let timestamp: Date
	let messageID: UUID

	init(text: String, sender: Sender, timestamp: Date = Date(), messageId: UUID = UUID()) {
		self.text = text
		self.user = sender
		self.timestamp = timestamp
		self.messageID = messageId
	}

	init?(snapshot: DataSnapshot) {
		guard
			let value = snapshot.value as? [String: AnyObject],
			let text = value["text"] as? String,
			let displayName = value["displayName"] as? String,
			let senderId = value["senderId"] as? String,
			let timestamp = value["timestamp"] as? String,
			let uuidFromStr = UUID(uuidString: snapshot.key),
			let dateFromStr = dateFormatter.date(from: timestamp) else {
			return nil
		}

		self.text = text
		self.user = Sender(id: senderId, displayName: displayName)
		self.timestamp = dateFromStr
		self.messageID = uuidFromStr
	}

	func toDictionary() -> Any {
		return [
			"text": text,
			"senderId": user.id,
			"displayName": user.displayName,
			"timestamp": dateFormatter.string(from: timestamp),
		]
	}
}

extension Message: MessageType {
	var messageId: String {
		return self.messageID.uuidString
	}

	var sender: SenderType {
		return Sender(senderId: user.id, displayName: user.displayName)
	}

	var sentDate: Date {
		return timestamp
	}

	var kind: MessageKind {
		return .text(text)
	}
}
