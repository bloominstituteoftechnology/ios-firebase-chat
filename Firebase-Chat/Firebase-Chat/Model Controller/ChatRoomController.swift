//
//  ChatRoomController.swift
//  Firebase-Chat
//
//  Created by Marlon Raskin on 9/17/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import FirebaseDatabase


class ChatRoomController {

	let reference = DatabaseReference()
	var chatRooms: [ChatRoom] = []
	let roomRef = Database.database().reference(withPath: "chatrooms")


	func createChatRoom(with chatRoom: ChatRoom) {
		let chatRoomRef = self.roomRef.child(chatRoom.chatRoomId.uuidString)
		chatRoomRef.setValue(chatRoom.toDictionary())
	}


	func fetchChatRooms(completion: @escaping () -> Void) {
		roomRef.observe(.value, with: { snapshot in
			var newRooms: [ChatRoom] = []
			for child in snapshot.children {
				if let snapshot = child as? DataSnapshot,
					let chatRoom = ChatRoom(snapshot: snapshot) {
					newRooms.append(chatRoom)
				}
			}
			self.chatRooms = newRooms
			completion()
		})
	}


}
