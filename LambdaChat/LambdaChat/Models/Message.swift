//
//  Message.swift
//  LambdaChat
//
//  Created by Jeffrey Santana on 9/17/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import Firebase
import MessageKit

struct Message {
	let id: UUID
//	let sender: Sender
	let message: String
	let timestamp: Date
	
	var senderId: String
	var senderName: String
	
	init(id: UUID = UUID(), from sender: Sender, with message: String, timestamp: Date = Date()) {
		self.id = id
//		self.sender = sender
		self.message = message
		self.timestamp = timestamp
		
		senderId = sender.id
		senderName = sender.displayName
	}
	
	init?(snapshot: DataSnapshot) {
		guard
			let value = snapshot.value as? [String: AnyObject],
			let senderId = value["senderId"] as? String,
			let senderName = value["senderName"] as? String,
			let message = value["message"] as? String,
			let timesString = value["timestamp"] as? String,
			let timestamp = timesString.transformToIsoDate else {
				return nil
		}
		
		self.id = UUID(uuidString: snapshot.key) ?? UUID()
		self.senderId = senderId
		self.senderName = senderName
		self.message = message
		self.timestamp = timestamp
	}
	
	func toDictionary() -> Any {
		return [
			"senderId": senderId,
			"senderName": senderName,
			"message": message,
			"timestamp": timestamp.transformIsoToString
		]
	}
}

extension Message: MessageType {
	var messageId: String {
		return id.uuidString
	}
	
	var sender: SenderType {
		return Sender(senderId: senderId, displayName: senderName)
	}
	
	var sentDate: Date {
		return timestamp
	}
	
	var kind: MessageKind {
		return .text(message)
	}
}
