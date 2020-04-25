//
//  ChatRoomController.swift
//  Firebase Chat
//
//  Created by David Wright on 4/24/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import MessageKit
import Firebase

class ChatRoomController {
    
    // MARK: Properties

    var chatRooms: [ChatRoom] = []
    var currentUser: Sender?
    
    var ref: DatabaseReference!
    
    // MARK: Methods

    func fetchChatRooms(completion: @escaping () -> Void) {
        // TODO: Implement fetchChatRooms()
    }
    
    func fetchMessages(in chatRoom: ChatRoom, completion: @escaping () -> Void) {
        // TODO: Implement fetchMessages()
    }
    
    func createChatRoom(titled title: String, completion: @escaping () -> Void) {
        // TODO: Implement createChatRoom()
    }
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, from sender: Sender, completion: @escaping () -> Void) {
        // TODO: Implement createMessage()
    }
    
    // MARK: - Initializers

    init() {
        self.ref = Database.database().reference()
    }
}
