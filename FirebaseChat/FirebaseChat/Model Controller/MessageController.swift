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
    
    var chatRooms = [ChatRoom]()
    let ref = Database.database().reference().child("ChatRooms")
    var currentUser: Sender? = Sender(id: UIDevice().name, displayName: UIDevice().name)
    
    
    //baseURL - Not needed with new method
    static let baseURL = URL(string: "https://fir-chatroom-4b274.firebaseio.com/")!
     
    // Create/Add Chatroom
    func addChatRoom(with name:String, completion: @escaping () -> ()) {
        let room = ChatRoom(id: UUID().uuidString, messages: [], name: name)
        self.chatRooms.append(room)
        updateFirebaseDB()
        completion()
    }
    // Fetch Chatroom
    
    func fetchChatRoom(completion: @escaping () -> ()) {
        ref.observe(.value) { snapshot in
            let decoder = FirebaseDecoder()
            let rooms = try! decoder.decode(Rooms.self, from: snapshot.value as Any)
            self.chatRooms = rooms.rooms
            completion()
        }
    }
    
    // Create Message in chatroom
    func addNewMessageinRoom(in chatRoom: ChatRoom, message: Message, from sender: Sender, completion: @escaping () -> ()) {
        guard let index = chatRooms.firstIndex(of: chatRoom) else { return }
        
        var messagesArray = [Message]()
        if let messages = self.chatRooms[index].messages {
            messagesArray = messages
            messagesArray.append(message)
        } else {
            messagesArray = [message]
        }
        chatRooms[index].messages = messagesArray
        updateFirebaseDB()
        completion()
    }

     
    
    
    //Update Firebase DB
    
    func updateFirebaseDB() {
        let rooms = Rooms(rooms: self.chatRooms)
        let encoder = FirebaseEncoder()
        let roomsData = try? encoder.encode(rooms)
        ref.setValue(roomsData)
        
    }

    
}


