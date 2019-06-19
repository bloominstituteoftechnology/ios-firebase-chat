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

	var monitor: DatabaseHandle?

	func fetchChatrooms(completion: @escaping () -> Void) {
		FirebaseController.dbChatrooms.observeSingleEvent(of: .value) { [weak self] (snapshot) in
			var chatrooms = [Chatroom]()
			for child in snapshot.children {
				guard let chatroomDict = (child as? DataSnapshot)?.value as? [String: Any] else { continue }
				do {
					let chatroom = try Chatroom.fromDict(chatroomDict)
					chatrooms.append(chatroom)
				} catch {
					NSLog("Problem decoding remote chatroom data: \(error)")
				}
			}
			self?.chatrooms = chatrooms

			completion()
		}
	}

	func monitorChatrooms(completion: @escaping ([Int]) -> Void = { _ in }) {
		monitor = FirebaseController.dbChatrooms.observe(.value, with: { [weak self] (snapshot) in
			guard let self = self else { completion([]); return }
			var newChatrooms = [Chatroom]()
			for child in snapshot.children {
				guard let chatroomDict = (child as? DataSnapshot)?.value as? [String: Any] else { continue }
				do {
					let chatroom = try Chatroom.fromDict(chatroomDict)
					if self.chatrooms.contains(chatroom) == true {
						continue
					}
					newChatrooms.append(chatroom)
				} catch {
					NSLog("Problem decoding remote chatroom data: \(error)")
				}
			}
			let rangeLow = self.chatrooms.count
			self.chatrooms.append(contentsOf: newChatrooms)
			let rangeHigh = self.chatrooms.count
			let updatedRows = (rangeLow..<rangeHigh).map { Int($0) }
			completion(updatedRows)
		})
	}

	func createChatroom(topic: String, completion: @escaping () -> Void = {} ) {
		let newChatroom = Chatroom(topic: topic)

		do {
			let chatroomDict = try newChatroom.toDict()
			FirebaseController.dbChatrooms.child(newChatroom.id.uuidString).setValue(chatroomDict) { (error, ref) in
				completion()
			}
		} catch {
			NSLog("Couldn't create chatroom dict: \(error)")
		}

	}
}
