//
//  Firebase_ChatTests.swift
//  Firebase ChatTests
//
//  Created by Michael Redig on 6/18/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import XCTest
@testable import Firebase_Chat
import Firebase

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
		let testTime = dict["timestamp"] as! Double
		let testSender = dict["sender"] as! String
		let testSenderID = dict["senderID"] as! String
		XCTAssertEqual(testText, inMessage)
		XCTAssertEqual(testTime, date.timeIntervalSince1970)
		XCTAssertEqual(testSender, sender)
		XCTAssertEqual(testSenderID, id.uuidString)

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
		XCTAssertEqual(date.timeIntervalSince1970, message.timestamp.timeIntervalSince1970)
		XCTAssertEqual(id, message.senderID)
	}

	func testConvertChatroomToDictionary() {
		let topic = "I'm Mr. Meeseeks look at me!"
		let date = Date()
		let id = UUID()
		let chatroom = Chatroom(topic: topic, created: date, id: id)
		let dict = try! chatroom.toDict()

		XCTAssertNotNil(dict)
		let testTopic = dict["topic"] as! String
		let testCreated = dict["created"] as! Double
		let testID = dict["id"] as! String
		XCTAssertEqual(testTopic, topic)
		XCTAssertEqual(testCreated, date.timeIntervalSince1970)
		XCTAssertEqual(testID, id.uuidString)
	}

	func testCreateChatroom() {
		let chatroomController = ChatroomController()
		let waitForFinish = expectation(description: "Waiting")

		chatroomController.createChatroom(topic: "Test Topic") {
			waitForFinish.fulfill()
		}
		waitForExpectations(timeout: 10) { (error) in
			if let error = error {
				XCTFail("Timed out waiting for firebase sync: \(error)")
			}
		}
	}

	func testFetchChatrooms() {
		let chatroomController = ChatroomController()
		let waitForFinish = expectation(description: "Waiting")

		chatroomController.fetchChatrooms {
			waitForFinish.fulfill()
		}
		waitForExpectations(timeout: 10) { (error) in
			if let error = error {
				XCTFail("Timed out waiting for firebase sync: \(error)")
			}
		}
	}
}
