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
		let text = "This is a message"
		let senderName = "ME"
		let sentDate = Date()
		let id = UUID()
		let senderID = UUID()
		let message = Message(text: text, senderName: senderName, senderID: senderID, id: id, sentDate: sentDate)

		let dict = try! message.toDict()

		XCTAssertNotNil(dict)
		let testText = dict["text"] as! String
		let testTime = dict["sentDate"] as! Double
		let testSender = dict["senderName"] as! String
		let testSenderID = dict["senderID"] as! String
		let testID = dict["id"] as! String
		XCTAssertEqual(testText, text)
		XCTAssertEqual(testTime, sentDate.timeIntervalSince1970)
		XCTAssertEqual(testSender, senderName)
		XCTAssertEqual(testSenderID, senderID.uuidString)
		XCTAssertEqual(testID, id.uuidString)

	}

	func testConvertMessageFromDictionary() {
		let text = "This is a message"
		let senderName = "ME"
		let sentDate = Date()
		let id = UUID()
		let senderID = UUID()

		let dict = ["text": text, "sentDate": sentDate.timeIntervalSince1970, "senderName": senderName, "senderID": senderID.uuidString, "id": id.uuidString] as [String : Any]

		let message = try! Message.fromDict(dict)

		XCTAssertNotNil(message)
		XCTAssertEqual(text, message.text)
		XCTAssertEqual(senderName, message.senderName)
		XCTAssertEqual(sentDate.timeIntervalSince1970, message.sentDate.timeIntervalSince1970)
		XCTAssertEqual(senderID, message.senderID)
		XCTAssertEqual(id, message.id)
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
		XCTAssert(chatroomController.chatrooms.count == 0)

		chatroomController.fetchChatrooms {
			waitForFinish.fulfill()
		}
		waitForExpectations(timeout: 10) { (error) in
			if let error = error {
				XCTFail("Timed out waiting for firebase sync: \(error)")
			}
		}
		XCTAssert(chatroomController.chatrooms.count > 0)
	}

	func testCreateNewMessage() {
		let messageController = MessageController()
		let waitForFinish = expectation(description: "Waiting")
		messageController.selectedChatroom = Chatroom(topic: "SampleChatroom")

		let messageCount = messageController.currentMessageThread.count
		XCTAssert(messageCount == 0)

		messageController.createNewMessage(withText: "IMA FIRING MAH LAZORZ") { error in
			if let error = error {
				XCTFail("failed cuz of \(error)")
			}
			waitForFinish.fulfill()
		}
		waitForExpectations(timeout: 10) { (error) in
			if let error = error {
				XCTFail("Timed out waiting for an expectation: \(error)")
			}
		}

		let waitForLoad = expectation(description: "Waiting")
		messageController.monitorChatroomMessage { _ in
			waitForLoad.fulfill()
		}
		waitForExpectations(timeout: 10) { (error) in
			if let error = error {
				XCTFail("Timed out waiting for an expectation: \(error)")
			}
		}

		let updatedMessageCount = messageController.currentMessageThread.count
		XCTAssert(updatedMessageCount > messageCount)
	}
}
