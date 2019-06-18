//
//  Firebase_ChatTests.swift
//  Firebase ChatTests
//
//  Created by Michael Redig on 6/18/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import XCTest
@testable import Firebase_Chat

class Firebase_ChatTests: XCTestCase {

	func testConvertMessageToDictionary() {
		let inMessage = "This is a message"
		let sender = "ME"
		let date = Date()
		let id = UUID()
		let message = Message(text: inMessage, timestamp: date, sender: sender, senderID: id)

		let dict = try! message.toDict()

		XCTAssertNotNil(dict)
		let testText = dict["text"] as! String
		XCTAssertEqual(testText, inMessage)
	}

	func testConvertMessageFromDictionary() {
		let inMessage = "This is a message"
		let sender = "ME"
		let date = Date()
		let id = UUID()

		let dict = ["text": inMessage, "timestamp": date.timeIntervalSince1970, "sender": sender, "senderID": id.uuidString] as [String : Any]

		let message = try! Message.fromDict(dict)

		XCTAssertNotNil(message)
		XCTAssertEqual(inMessage, message.text)
		XCTAssertEqual(sender, message.sender)
		XCTAssertEqual(date, message.timestamp)
		XCTAssertEqual(id, message.senderID)
	}
}
