//
//  FirebaseController.swift
//  Firebase Chat
//
//  Created by Michael Redig on 6/18/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseController {
	static var dbRoot = Database.database().reference().child("FirebaseChat")
	static var dbChatrooms = Database.database().reference().child("FirebaseChat").child("chatrooms")
	static var dbMessages = Database.database().reference().child("FirebaseChat").child("messages")
}
