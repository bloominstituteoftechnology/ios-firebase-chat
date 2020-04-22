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

class ChatRoomController: NSObject {
    
    // MARK: - CRUD
    
    private(set) var chatRooms: [ChatRoom] = [] { didSet { tableView?.reloadData() }}

    weak var tableView: UITableView?
    
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
    
    override init() {
        super.init()
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

// MARK: - Table View Data Source

extension ChatRoomController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.tableView = tableView
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)

        cell.textLabel?.text = chatRooms[indexPath.row].name

        return cell
    }
}



