//
//  MessageController.swift
//  Firebase Chat
//
//  Created by Michael Redig on 6/18/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

class MessageController {
	var currentUser: User? {
		return User.defaultSender()
	}
	var selectedChatroom: Chatroom? {
		didSet {
//			updateMessages()
		}
	}
	var currentMessageThread = [Message]()

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
