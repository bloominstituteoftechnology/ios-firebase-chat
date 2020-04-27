//
//  MessageController.swift
//  FirebaseChat
//
//  Created by Sal B Amer on 4/26/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//
import CodableFirebase
import Firebase
import MessageKit
import UIKit

// Resources -   https://firebase.google.com/docs/database/ios/read-and-write
//              https://firebase.google.com/docs/database/ios/structure-data

class MessageController {
    
    var rooms = [ChatRoom]()
    let ref = Database.database().reference().child("ChatRooms")
    
    //baseURL
    static let baseURL = URL(string: "https://fir-chatroom-4b274.firebaseio.com/")!
     
    // Create/Add Chatroom
    func addChatRoom(with name:String, completion: @escaping () -> ()) {
        let room = ChatRoom(id: UUID().uuidString, messages: [], name: name)
        self.rooms.append(room)
        updateFirebaseDB()
        completion()
    }
    // Fetch Chatroom
    
    func fetchChatRoom(completion: @escaping () -> ()) {
        ref.observe(.value) { (snapshot) in
            let decoder = FirebaseDecoder()
//            let rooms = try decoder.decode(Rooms.self, from: snapshot.value as Any)
//            self.rooms = rooms.rooms
            completion()
        }
    }
    
    // Create Message in chatroom

    // Fetch Messages in chatroom
    
    
    //Update Firebase DB
    
    func updateFirebaseDB() {
        let rooms = Rooms(rooms: self.rooms)
        let encoder = FirebaseEncoder()
        let roomsData = try? encoder.encode(rooms)
        ref.setValue(roomsData)
        
    }

    
}


