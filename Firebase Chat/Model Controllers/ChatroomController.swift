//
//  ChatroomController.swift
//  Firebase Chat
//
//  Created by Michael Redig on 6/18/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class ChatroomController {
	var chatrooms = [Chatroom]()

	func fetchChatrooms(completion: @escaping () -> Void) {
		FirebaseController.dbChatrooms.observeSingleEvent(of: .value) { [weak self] (snapshot) in
			guard let chatroomDicts = snapshot.value as? [String: [String: Any]] else {
				fatalError("Invalid remote chatroom data")
			}
			var chatrooms = [Chatroom]()
			for (_, chatroomDict) in chatroomDicts.enumerated() {
				do {
					let chatroom = try Chatroom.fromDict(chatroomDict.value)
					chatrooms.append(chatroom)
				} catch {
					NSLog("Problem decoding remote chatroom data: \(error)")
				}
			}
			self?.chatrooms = chatrooms

			completion()
		}
	}

	func createChatroom(topic: String, completion: @escaping () -> Void = {} ) {
		let newChatroom = Chatroom(topic: topic)

		do {
			let chatroomDict = try newChatroom.toDict()
//			FirebaseController.dbChatrooms.child(newChatroom.id.uuidString).setValue(chatroomDict)
			FirebaseController.dbChatrooms.child(newChatroom.id.uuidString).setValue(chatroomDict) { (error, ref) in
				completion()
			}
		} catch {
			NSLog("Couldn't create chatroom dict: \(error)")
		}

	}
}
