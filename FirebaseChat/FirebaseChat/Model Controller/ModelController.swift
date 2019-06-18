//
//  ModelController.swift
//  FirebaseChat
//
//  Created by Christopher Aronson on 6/18/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class ModelController {
    
    lazy var db = Firestore.firestore()
    
    var chatRooms = [ChatRoom]()
    
    func createCharRoom(with chatRoomName: String, completion: @escaping (Error?) -> Void) {
        
        db.collection("chatRooms").document(chatRoomName).setData([ : ]) { error in
            
            if let error = error {
                completion(error)
                return
            }
            
            let newRoom = ChatRoom(chatRoomName: chatRoomName, messages: [])
            self.chatRooms.append(newRoom)
            
            completion(nil)
        }
    }
    
    
    
    
    
}


