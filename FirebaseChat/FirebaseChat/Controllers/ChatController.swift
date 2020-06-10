//
//  ChatController.swift
//  FirebaseChat
//
//  Created by Thomas Dye on 06/5/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import Foundation
import MessageKit
import Firebase

class ChatController {
    private(set) var chatRooms: [ChatRoom] = []
    let ref = Database.database().reference()
    
    init() {
//        fetchChatRooms()
    }
    
    func fetchChatRooms(completion: @escaping () -> Void) {
        ref.child("ChatRooms").observeSingleEvent(of: .value) { (snapshot) in
            if let chatRoomDictionary = snapshot.value as? [String : [String : Any]] {
                let chatRoomArray = chatRoomDictionary.values
                for room in chatRoomArray {
                    let chatRoom = ChatRoom(chatRoomID: room["chatRoomID"] as! String,
                                            title: room["title"] as! String,
                                            created: Date(timeIntervalSince1970: TimeInterval(room["created"] as! Int64)),
                                            lastUpdated: Date(timeIntervalSince1970: TimeInterval(room["lastUpdated"] as! Int64))
                    )
                    self.chatRooms.append(chatRoom)
                    print("Added chatroom \(chatRoom.title)")
                    completion()
                }
            }
        }
    }
}
