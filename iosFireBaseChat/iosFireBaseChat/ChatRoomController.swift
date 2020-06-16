//
//  ChatRoomController.swift
//  iosFireBaseChat
//
//  Created by Kelson Hartle on 6/16/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class ChatRoomController {
    
    static let baseURL = URL(string: "https://ios-firebasechat-56afb.firebaseio.com")!
    var chatRooms: [ChatRoom] = []
    let reference = Database.database().reference()
    var currentUser: ChatRoom.Message.Sender?
    
    func fetchMessageThreads(completion: @escaping () -> Void) {
        
        
            
            
    }
    
    func createChatRoom(with title: String, completion: @escaping () -> Void) {
        
        let newChatRoom = ChatRoom(title: title)
        
        let dictionaryForChatRoom: [String: Any] =
            [
                "identifier" :                                     newChatRoom.identifier,
                "title" : newChatRoom.title,
                "messages" : ["messages" : newChatRoom.messages]]
        
        self.chatRooms.append(newChatRoom)
        
        reference.child(newChatRoom.identifier).setValue(dictionaryForChatRoom) { (error: Error?, ref: DatabaseReference) in
            if let error = error {
                print("Data could not be saved to database: \(error)")
            } else {
                print("Data was saved to database")
            }
        }
    }
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, sender: String, completion: @escaping () -> Void) {
        
        
    }
}
