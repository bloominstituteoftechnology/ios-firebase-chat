//
//  ChatController.swift
//  FirebaseChat
//
//  Created by Shawn Gee on 4/21/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MessageKit

class ChatRoomController {
    
    // MARK: - CRUD
    
    private(set) var chatRooms: [ChatRoom] = [] { didSet {
        chatRoomUpdate?()
    }}

    var chatRoomUpdate: (() -> Void)?
    
    @discardableResult
    func createChatRoom(name: String) -> ChatRoom {
        let chatRoomID = UUID().uuidString
        databaseRef.child("chatRooms").child(chatRoomID).child("name").setValue(name)
        databaseRef.child("chatRooms").child(chatRoomID).child("id").setValue(chatRoomID)
        
        return ChatRoom(name: name, id: chatRoomID)
    }
    
    // MARK: - Private Properties
    
    private var databaseRef: DatabaseReference = Database.database().reference()
    private lazy var chatRoomsRef = databaseRef.child("chatRooms").ref
    
    // MARK: - Init
    
    init() {
        setUpObservers()
        // TODO: Remove observers
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




