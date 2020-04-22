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
    
    private(set) var chatRooms: [ChatRoom] = [] { didSet { chatRoomsDidSet?() }}

    var chatRoomsDidSet: (() -> Void)?
    
    @discardableResult
    func createChatRoom(name: String) -> ChatRoom {
        let chatRoomID = UUID().uuidString
        chatRoomsRef.child(chatRoomID).child(ChatRoom.Keys.name).setValue(name)
        chatRoomsRef.child(chatRoomID).child(ChatRoom.Keys.id).setValue(chatRoomID)
        
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
        let chatRoomsQuery = chatRoomsRef.queryOrdered(byChild: ChatRoom.Keys.name)
        
        chatRoomsQuery.observe(.value) { (snapshot) in
            var chatRooms = [ChatRoom]()
            for child in snapshot.children {
                guard
                    let childSnapshot = child as? DataSnapshot,
                    let chatRoomDict = childSnapshot.value as? [String: String],
                    let chatRoom = ChatRoom(with: chatRoomDict) else { continue }
                
                chatRooms.append(chatRoom)
            }
            self.chatRooms = chatRooms
        }
    }
}




