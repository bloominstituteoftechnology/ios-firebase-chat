//
//  Room.swift
//  firebase-chat
//
//  Created by Hector Steven on 6/25/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation

struct Room {
	let id: String
	let roomname: String
	var messages: [Message]
	
	init(roomname: String, id: String = UUID().uuidString, messages: [Message] = []) {
		self.id = id
		self.roomname = roomname
		self.messages = messages
	}
}
