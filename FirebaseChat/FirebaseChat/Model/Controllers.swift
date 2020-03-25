//
//  RoomController.swift
//  FirebaseChat
//
//  Created by Lambda_School_Loaner_268 on 3/24/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import Firebase
import MessageKit
import FirebaseDatabase


public  var ref: DatabaseReference! = Database.database().reference().child("ChatRooms")

class RoomController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    var chatRooms: [ChatRoom] = []
    
    var ref: DatabaseReference! = Database.database().reference().child("ChatRooms")
    
    // MARK: - Room Controller Methods
    func createChatRoom(with roomName: String, completion: @escaping () -> ()) {
            
        let room = ChatRoom(roomName: roomName, messages: [], identifier: UUID().uuidString)
        
        let dictRoom: [String : Any] = ["roomName": room.roomName, "identifier": room.identifier, "messages": ["messages": room.messages]]
        
        
        self.chatRooms.append(room)
        
        ref.child(room.identifier).setValue(dictRoom) {
            (error: Error?, ref: DatabaseReference) in
            if let error = error{
                NSLog("\(error)")
            } else {
                NSLog("Update successful")
            }
    }
    }
    
    func fetchChatRooms(completion: @escaping () -> ()) {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in

        guard let value = snapshot.value as? [String: [String: Any]] else { return }
        
        let chatRoomIds = value.map({ $0.key })
        var index = 0
        
        let _ = value.values.map { chatRoomDict in
            self.helperFunc(chatRoomIds[index], chatRoomDict)
            index += 1
        }
        completion()
        })
        }
    func helperFunc(_ identifier: String, _ dict: [String: Any]) {
        for room in self.chatRooms {
            if room.identifier == identifier {
                return
            }
        }
        let room = ChatRoom(roomName: dict["roomName"] as! String, identifier: dict["identifier"] as! String)
        self.chatRooms.append(room)
        }
}

class MessageController {
   
    func fetchMessages(in room: ChatRoom, completion: @escaping() -> Void) {
        ref.child(room.identifier).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: [String: Any]] else { return }
            let _ = value.values.map { dict in
                    room.fetchMessage(from: dict)
            }
            completion()
        })
    }
    
    func createMessage(in room: ChatRoom, with text: String, sender: Sender, completion: @escaping () -> Void) {
        let message = Message(text: text, sender: sender, sentDate: Date(), timestamp: Date().description, messageId: UUID().uuidString)
        
        ref.child(room.identifier).childByAutoId().setValue(message.toDict()) {
                (error: Error?, ref: DatabaseReference) in
                if let error = error {
                    print("Data Could not be saved \(error).")
                } else {
                    print("Data saved succesfully!")
                    room.messages.append(message)
                    completion()
            }
        }
    }
}

    
    



