//
//  MessageController.swift
//  Firebase-Chat
//
//  Created by Marlon Raskin on 9/17/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import Firebase
import MessageKit

class MessageController {

	let reference = DatabaseReference()
	var messages: [Message] = []
	let messageRef = Database.database().reference(withPath: "messages")
	var currentUser: Sender?
}
