//
//  MessageController.swift
//  Firebase-Chat
//
//  Created by Marlon Raskin on 9/17/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import Firebase
import MessageKit

class MessageController {

	let reference = DatabaseReference()
	var messages: [Message] = []
	let messagesRef = Database.database().reference(withPath: "messages")
	var currentUser: Sender?


	func createMessage(chatRoom: ChatRoom, with text: String, sender: Sender, timestamp: Date = Date(), messageId: UUID = UUID()) {
		let message = Message(text: text, sender: sender)
		let childRef = self.messagesRef.child(chatRoom.chatRoomId.uuidString)
		let messageRef = childRef.child(message.id.uuidString)
		messageRef.setValue(message.toDictionary())

	}

	func fetchMessages(with chatRoom: ChatRoom, completion: @escaping () -> Void) {
		let childRef = self.messagesRef.child(chatRoom.chatRoomId.uuidString)
		var newMessages: [Message] = []
		childRef.observe(.value, with: { snapshot in
			for child in snapshot.children {
				if let snapshot = child as? DataSnapshot,
					let message = Message(snapshot: snapshot) {
					newMessages.append(message)
				}
			}
			self.messages = newMessages
			completion()
		})
	}
}
