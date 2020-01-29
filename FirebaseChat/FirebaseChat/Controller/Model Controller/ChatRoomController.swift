//
//  ChatRoomController.swift
//  FirebaseChat
//
//  Created by Chad Rutherford on 1/28/20.
//  Copyright © 2020 chadarutherford.com. All rights reserved.
//

import CodableFirebase
import Firebase
import Foundation
import MessageKit

class ChatRoomController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    var rooms = [ChatRoom]()
    let chatRoomRef = Database.database().reference().child("chatRooms")
    
    func fetchRooms(completion: @escaping () -> ()) {
        chatRoomRef.observe(.value) { snapshot in
            let decoder = FirebaseDecoder()
            let rooms = try! decoder.decode(Rooms.self, from: snapshot.value as Any)
            self.rooms = rooms.rooms
            completion()
        }
    }
    
    func addRoom(with name: String, completion: @escaping () -> ()) {
        let room = ChatRoom(id: UUID().uuidString, messages: [], name: name)
        self.rooms.append(room)
        updateDatabase()
        completion()
    }
    
    func deleteRoom(_ room: ChatRoom, completion: @escaping () -> ()) {
        guard let index = rooms.firstIndex(of: room) else { return }
        rooms.remove(at: index)
        updateDatabase()
        completion()
    }
    
    func addMessageToRoom(_ room: ChatRoom, message: Message, completion: @escaping () -> ()) {
        guard let index = rooms.firstIndex(of: room) else { return }
        
        var messageArray = [Message]()
        
        if let messages = self.rooms[index].messages {
            messageArray = messages
            messageArray.append(message)
        } else {
            messageArray = [message]
        }
        
        rooms[index].messages = messageArray
        
        updateDatabase()
        completion()
    }
    
    private func updateDatabase() {
        let rooms = Rooms(rooms: self.rooms)
        let encoder = FirebaseEncoder()
        let roomsData = try? encoder.encode(rooms)
        chatRoomRef.setValue(roomsData)
    }
}
