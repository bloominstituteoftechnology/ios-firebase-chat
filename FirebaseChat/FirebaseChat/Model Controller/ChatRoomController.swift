//
//  ChatRoomController.swift
//  FirebaseChat
//
//  Created by John Kouris on 12/7/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import Foundation
import Firebase

class ChatRoomController {
    var chatRooms: [ChatRoom] = []
    var dbRef: DatabaseReference = Database.database().reference()
    
    func createChatRoom() {
        
        let chatRoomData: [String: Any] = ChatRoom.init(snapshot: snapshot)
        
    }
    
}
