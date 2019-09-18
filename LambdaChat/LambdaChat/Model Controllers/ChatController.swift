//
//  ChatController.swift
//  LambdaChat
//
//  Created by Jeffrey Santana on 9/17/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import FirebaseDatabase
import MessageKit

class ChatController {
	
	//MARK: - Properties
	
	let ref = Database.database().reference()
	let groupsRef: DatabaseReference
	let messagesRef: DatabaseReference
	var groups = [Group]()
	var messages = [Message]()
	var users = [Sender]()
	
	//MARK: - Helpers
	
	init() {
		groupsRef = ref.child("groups")
		messagesRef = ref.child("messages")
	}
	
	//MARK: - Create
	
	func createGroup(with title: String, completion: @escaping () -> Void) {
		let newGroup = Group(title: title)
		
		groupsRef.child((newGroup.id.uuidString)).setValue(newGroup.toDictionary())
		completion()
	}
	
	func createMessage(for group: Group, from sender: Sender, with message: String, completion: @escaping () -> Void) {
		let newMessage = Message(from: sender, with: message)
		
		messagesRef.child(group.id.uuidString).child(newMessage.id.uuidString).setValue(newMessage.toDictionary())
		completion()
	}
	
	//MARK: - Read
	
	func fetchGroups(completion: @escaping () -> Void) {
		groupsRef.observe(.value, with: { snapshot in
			var newGroups = [Group]()
			for child in snapshot.children {
				if let snapshot = child as? DataSnapshot,
					let group = Group(snapshot: snapshot) {
					newGroups.append(group)
				}
			}
			self.groups = newGroups
			completion()
		})
	}
	
	func fetchMessages(for group: Group, completion: @escaping () -> Void) {
		messagesRef.child(group.id.uuidString).observe(.value, with: { snapshot in
			var newMessages = [Message]()
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
	
	//MARK: - Update
	
	
	//MARK: - Delete
	
	
}


