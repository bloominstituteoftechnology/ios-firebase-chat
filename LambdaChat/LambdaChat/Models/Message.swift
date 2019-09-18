//
//  Message.swift
//  LambdaChat
//
//  Created by Jeffrey Santana on 9/17/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

struct Message {
	let sender: String
	let message: String
	let timestamp: Date
	
	init(from sender: String, with message: String, timestamp: Date = Date()) {
		self.sender = sender
		self.message = message
		self.timestamp = timestamp
	}
	
	func toDictionary() -> Any {
		var dateFormatter: DateFormatter {
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
			return formatter
		}
		
		return [
			"sender": sender,
			"message": message,
			"timestamp": dateFormatter.string(from: timestamp)
		]
	}
}
