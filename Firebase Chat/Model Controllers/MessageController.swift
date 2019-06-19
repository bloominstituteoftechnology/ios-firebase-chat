//
//  MessageController.swift
//  Firebase Chat
//
//  Created by Michael Redig on 6/18/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MessageController {
	var currentUser: User? {
		return User.defaultSender()
	}
	var selectedChatroom: Chatroom?
	var currentMessageThread = [Message]()
	var monitor: DatabaseHandle?

	func monitorChatroomMessage(updater: @escaping ([Message]) -> Void) {
		guard let currentChatroom = selectedChatroom else {
			updater([])
			return
		}
		monitor = FirebaseController.dbMessages.child(currentChatroom.id.uuidString).observe(.value, with: { [weak self] (snapshot) in
			guard let self = self else { updater([]); return }
			var messages = [Message]()
			for child in snapshot.children {
				guard let messageDict = (child as? DataSnapshot)?.value as? [String: Any] else { continue }
				do {
					let message = try Message.fromDict(messageDict)
					messages.append(message)
				} catch {
					NSLog("Problem decoding remote message data: \(error)")
				}
			}
			self.currentMessageThread = messages.sorted { $0.sentDate < $1.sentDate }
			updater(messages)
		})
	}

	func createNewMessage(withText text: String, completion: @escaping (Error?) -> Void) {
		guard let currentUser = currentUser,
			let currentChatroom = selectedChatroom else {
			let error = NSError(domain: "com.ERRORDOMAIN", code: 12376, userInfo: nil)
			completion(error)
			return
		}
		let newMessage = Message(text: text, senderName: currentUser.displayName, senderID: currentUser.id)

		do {
			let messageDict = try newMessage.toDict()
			FirebaseController.dbMessages.child(currentChatroom.id.uuidString).childByAutoId().setValue(messageDict) { (error, databaseRef) in
				completion(error)
			}
		} catch {
			NSLog("Error creating new message: \(error)")
		}
	}
}
