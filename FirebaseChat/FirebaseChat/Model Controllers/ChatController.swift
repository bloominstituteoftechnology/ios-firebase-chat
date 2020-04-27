//
//  ChatController.swift
//  FirebaseChat
//
//  Created by Joshua Rutkowski on 4/26/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import CodableFirebase
import Firebase
import MessageKit
import UIKit

class ChatController {
    
    // Resources -   https://firebase.google.com/docs/database/ios/read-and-write
    //              https://firebase.google.com/docs/database/ios/structure-data
    
    // MARK: - Variables
    var rooms = [ChatRoom]()
    let ref = Database.database().reference().child("chatRooms")
    
    // MARK: - Functions
    func fetchRooms(completion: @escaping () -> ()) {
        ref.observe(.value) { snapshot in
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
        ref.setValue(roomsData)
    }
}
