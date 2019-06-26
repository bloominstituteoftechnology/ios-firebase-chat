//
//  RoomsController.swift
//  firebase-chat
//
//  Created by Hector Steven on 6/25/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation
import Firebase

class RoomsController {

	func testpush() {
		//self.ref.child("users").child(user.uid).setValue(["username": username])
		let room1 = Room(roomname: "Room#2")
		
		ref.child("rooms").child(room1.id).setValue(["name": room1.roomname])
	}
	
	func test2get() {
		ref.child("rooms").observe(DataEventType.value, with: { (snapshot) in
			if let postDict = snapshot.value as? [String: [String: String]] {
				let rooms = Array(postDict.values)
				print(rooms[0]["name"]!)
				
			} else {
				fatalError()
			}
		})
	}
	
	init(ref: DatabaseReference = Database.database().reference()) {
		self.ref = ref
	}
	
	var ref: DatabaseReference
}
