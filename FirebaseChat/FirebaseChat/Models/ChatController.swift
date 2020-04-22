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
    
    func getChatRoom(for chatRoomID: String, completion: (ChatRoom) -> Void) {
        
    }
    
    func getMessages(for chatRoomID: String, completion: ([Message]) -> Void) {
        messagesRef.child(chatRoomID).observeSingleEvent(of: .value) { (snapshot) in
            let messages = snapshot.value as? [[String: String]]
        }
    }
    
    // MARK: - Private Properties
    
    private var databaseRef: DatabaseReference = Database.database().reference()
    private lazy var chatRoomsRef = databaseRef.child("chatRooms").ref
    private lazy var messagesRef = databaseRef.child("messages").ref
    
    // MARK: - Private Methods
    
    private func setupObservers() {
        chatRoomsRef.observe(.value) { (snapshot) in
            guard let chatRoomsDict = snapshot.value as? [String: String] else { return }
            self.chatRoomsDict = chatRoomsDict
        }
    }
}




