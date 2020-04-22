//
//  ChatController.swift
//  FirebaseChat
//
//  Created by Shawn Gee on 4/21/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation
import FirebaseDatabase
import MessageKit

class ChatController {
    // MARK: - CRUD
    
    private(set) var chatRooms: [ChatRoom] = []

    func createChatRoom(name: String) -> ChatRoom {
        let chatRoomID = UUID().uuidString
        chatRoomsRef.child(chatRoomID).setValue(name, forKey: "name")
        chatRoomsRef.child(chatRoomID).setValue(chatRoomID, forKey: "id")
        
        return ChatRoom(name: name, id: chatRoomID)
    }
    
    // MARK: - Private Properties
    
    private var databaseRef: DatabaseReference = Database.database().reference()
    private lazy var chatRoomsRef = databaseRef.child("chatRooms").ref
    
    // MARK: - Init
    
    init() {
        setUpObservers()
    }
    
    // MARK: - Private Methods
    
    private func setUpObservers() {
        let chatRoomsQuery = chatRoomsRef.queryOrdered(byChild: "name")
        chatRoomsQuery.observe(.value) { (snapshot) in
            guard let chatRoomsDicts = snapshot.value as? [String: [String: String]] else { return }
            self.chatRooms = chatRoomsDicts.values.compactMap { ChatRoom(with: $0) }
        }
    }
}




