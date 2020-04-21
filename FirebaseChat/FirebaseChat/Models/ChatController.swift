//
//  ChatController.swift
//  FirebaseChat
//
//  Created by Shawn Gee on 4/21/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChatController {
    // MARK: - CRUD
    
    private(set) var chatRoomsDict: [String: String] = [:]// [id: name]

    func createChatRoom(name: String) -> ChatRoom {
        let chatRoomID = UUID().uuidString
        chatRoomsRef.child(chatRoomID).setValue(name, forKey: "name")
        
        return ChatRoom(name: name, messages: [], id: chatRoomID)
    }
    
    // MARK: - Private Properties
    
    private var databaseRef: DatabaseReference = Database.database().reference()
    private lazy var chatRoomsRef = databaseRef.child("chatRooms").ref
    
    // MARK: - Private Methods
    
    private func setupObservers() {
        chatRoomsRef.observe(.value) { (snapshot) in
            guard let chatRoomsDict = snapshot.value as? [String: String] else { return }
        }
    }
}




