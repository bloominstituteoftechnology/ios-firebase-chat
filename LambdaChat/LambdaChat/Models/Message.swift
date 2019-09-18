//
//  Message.swift
//  LambdaChat
//
//  Created by Jeffrey Santana on 9/17/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import Firebase

struct Message {
	let sender: String
	let message: String
	let timestamp: Date
	
	init(from sender: String, with message: String, timestamp: Date = Date()) {
		self.sender = sender
		self.message = message
		self.timestamp = timestamp
	}
	
	init?(snapshot: DataSnapshot) {
		guard
			let value = snapshot.value as? [String: AnyObject],
			let sender = value["sender"] as? String,
			let message = value["message"] as? String,
			let timesString = value["timestamp"] as? String,
			let timestamp = timesString.transformToIsoDate else {
				return nil
		}
		
		self.sender = sender
		self.message = message
		self.timestamp = timestamp
	}
	
	func toDictionary() -> Any {
		return [
			"sender": sender,
			"message": message,
			"timestamp": timestamp.transformIsoToString
		]
	}
}
