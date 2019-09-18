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
	
	var ref: DatabaseReference!
	var groups: [Group]?
	
	//MARK: - Helpers
	
	init() {
		ref = Database.database().reference()
	}
	
	//MARK: - Create
	
	func createGroup(with title: String) {
		let newGroup = Group(title: title)
		
		ref.child("groups").setValue(newGroup)
	}
	
	//MARK: - Read
	
	
	//MARK: - Update
	
	
	//MARK: - Delete
	
	
}


