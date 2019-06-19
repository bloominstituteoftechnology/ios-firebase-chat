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
		monitor = FirebaseController.dbMessages.observe(.value, with: { [weak self] (snapshot) in
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
			self.currentMessageThread = messages
			updater(messages)
		})
	}

	func createNewMessage(withText text: String, completion: @escaping () -> Void) {
		guard let currentUser = currentUser else { completion(); return }
		let newMessage = Message(text: text, senderName: currentUser.displayName, senderID: currentUser.id)

		do {
			let messageDict = try newMessage.toDict()
			FirebaseController.dbMessages.childByAutoId().setValue(messageDict) { (error, databaseRef) in
				completion()
			}
		} catch {
			NSLog("Error creating new message: \(error)")
		}
	}
}
