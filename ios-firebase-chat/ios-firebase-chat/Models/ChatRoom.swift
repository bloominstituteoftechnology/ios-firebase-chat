//
//  ChatRoom.swift
//  ios-firebase-chat
//
//  Created by Hector Steven on 6/25/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation

struct ChatRoom {
	// Fetching chatromos from fireBare
	init? (dictionary: [String: Any]) {
		guard let room = dictionary["room"] as? String else { return nil}
		self.room = room
	}
	
	//sending chatrooms to firebase
	
	var dictionaryRepresentation: [String: Any] {
		return ["room": room]
	}
	
	
	
	init(room: String) {//, id: String = UUID().uuidString) {
		self.room = room
//		self.id = id
	}
	
	let room: String
//	let id: String
	
	
	
	
}
