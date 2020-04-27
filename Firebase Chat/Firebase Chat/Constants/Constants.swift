//
//  Constants.swift
//  Firebase Chat
//
//  Created by David Wright on 4/26/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation

struct K {
    static let showChatSegue = "ShowChatSegue"
    static let chatCellIdentifier = "ChatRoomCell"
    
    static let testUser = Sender(senderId: "testUserID-555", displayName: "MissingNo.")
    static let testMessage = Message(text: "Test message", sender: testUser)
    static let testChat = ChatRoom(title: "Test Chat", messages: [testMessage])
    
    struct FIRKeys {
        static let chatRooms = "chatRooms"
        static let messages = "messages"
        static let users = "users"
    }
}
