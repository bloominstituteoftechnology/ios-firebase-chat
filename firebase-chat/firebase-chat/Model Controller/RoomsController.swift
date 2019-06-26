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

	func test() {
		ref.child("rooms")
	}
	
	func test2() {
		
	}
	
	init(ref: DatabaseReference = Database.database().reference()) {
		self.ref = ref
	}
	
	var ref: DatabaseReference
}
