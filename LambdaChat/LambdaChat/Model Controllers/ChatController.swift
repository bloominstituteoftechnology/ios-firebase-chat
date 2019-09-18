//
//  ChatController.swift
//  LambdaChat
//
//  Created by Jeffrey Santana on 9/17/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChatController {
	
	//MARK: - Properties
	
	let ref = Database.database().reference()
	let groupsRef: DatabaseReference
	let messagesRef: DatabaseReference
	var groups = [Group]()
	
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
	
	func createMessage(for group: Group, from sender: String, with message: String) {
		let newMessage = Message(from: sender, with: message)
		
		ref.child(group.id.uuidString).childByAutoId().setValue(newMessage.toDictionary())
	}
	
	//MARK: - Read
	
	func fetchGroups(completion: @escaping () -> Void) {
		groupsRef.observe(.value, with: { snapshot in
			var newGroups = [Group]()
			for child in snapshot.children {
				// 4
				if let snapshot = child as? DataSnapshot,
					let group = Group(snapshot: snapshot) {
					newGroups.append(group)
				}
			}
			self.groups = newGroups
			completion()
		})
	}
	
	//MARK: - Update
	
	
	//MARK: - Delete
	
	
}


