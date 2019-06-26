//
//  ChatRoom.swift
//  ios-firebase-chat
//
//  Created by Hector Steven on 6/25/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation

struct ChatRoom {
	
	init(room: String, id: String) {
		self.room = room
		self.id = id
	}
	
	let room: String
	let id: String
}
