//
//  ChatRoomController.swift
//  FirebaseChat
//
//  Created by Lambda_School_Loaner_204 on 12/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import Firebase
class ChatRoomController {
    
    var ref: DatabaseReference = Database.database().reference()
    var chatRooms: [ChatRoom] = []
    
    func fetchChatRooms(completion: @escaping () -> Void) {
        //ref = Database.database().reference()
        ref.child("Chat Rooms").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? [String: [String: Any]] else { return }

            let chatRoomIds = value.map({ $0.key })
            var index = 0
            let _ = value.values.map { chatRoomDictionary in
                self.createFetchedChatRooms(with: chatRoomIds[index], from: chatRoomDictionary)
                index += 1
            }
            completion()
            
            }) { (error) in print(error.localizedDescription)}
    }
    
    func createChatRoom(with title: String, completion: @escaping () -> Void) {
        
        let chatRoom = ChatRoom(title: title)
        //ref = Database.database().reference()
        var dataDictionary: [String: Any] = [:]
        dataDictionary["Title"] = chatRoom.title
        self.ref.child("Chat Rooms").child(chatRoom.identifier).setValue(dataDictionary) {
            (error: Error?, ref: DatabaseReference) in
            if let error = error {
                print("Data Could not be saved \(error).")
            } else {
                print("Data saved succesfully!")
                self.chatRooms.append(chatRoom)
                completion()
            }
        }
    }
    
    private func createFetchedChatRooms(with identifier: String, from dictionary: [String: Any]) {
            
        for chatroom in chatRooms {
            if chatroom.identifier == identifier {
                return
            }
        }
        let title = dictionary["Title"] as! String
        let chatRoom = ChatRoom(title: title, identifier: identifier)
        self.chatRooms.append(chatRoom)
//        if !self.chatRooms.contains(chatRoom) {
//            self.chatRooms.append(chatRoom)
//            print("title:\(chatRoom.title) id:\(chatRoom.identifier)")
//        }
    }
}
