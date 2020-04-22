//
//  ChatRoomsController.swift
//  Firebase Chat
//
//  Created by Wyatt Harrell on 4/21/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import Foundation
import MessageKit
import Firebase

class ChatRoomsController {
    
    var currentUser: Sender?
    
    var chatRooms: [ChatRoom] = []
    
    var ref: DatabaseReference
    
    init() {
        self.ref = Database.database().reference()
    }
    
    /*
         var ref: DatabaseReference! = Database.database().reference()
         var dataDictionary: [String: Any] = [:]
         dataDictionary["First Name"] = "Johnny"
         dataDictionary["Last name"] =  "Appleseed"
         ref.setValue(dataDictionary)
     */
    func fetchAllChatRooms(completion: @escaping () -> Void) {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String:[String:[String:String]]] else { return }
            print("⚠️ Value: \(value)")
            
            for (id,value) in value {
                print(value)
            }
            
            
            
            
        })
    }

    func createChatRoom(with title: String, completion: @escaping () -> Void) {

        let chatRoom = ChatRoom(title: title)
        
        let info = ["title": chatRoom.title,
                    "identifier": chatRoom.identifier]
        
        ref.child(chatRoom.identifier).setValue(info)
        
        self.chatRooms.append(chatRoom)
        completion()
        
    }
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, sender: Sender, completion: @escaping () -> Void) {
        
        guard let index = chatRooms.firstIndex(of: chatRoom) else { completion(); return }

        let newMessage = ChatRoom.Message(text: text, sender: sender)
        chatRooms[index].messages.append(newMessage)

        let message = ["text": text,
                       "displayName": newMessage.displayName,
                       "senderID": newMessage.senderID,
                       "timestamp": "\(newMessage.timestamp)",
                       "messageID": newMessage.messageId] as [String : String]
        ref.child(chatRoom.identifier).child(newMessage.messageId).setValue(message)
        completion()
        #warning("add completion closure to all methods")
        
    }
}
