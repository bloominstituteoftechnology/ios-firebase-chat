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

    func createChatRoom(with title: String, completion: @escaping () -> Void) {

        let chatRoom = ChatRoom(title: title)
        
        
        ref.child(chatRoom.identifier).setValue(chatRoom.title)
        
        self.chatRooms.append(chatRoom)
        completion()
        
    }
    
    func fetchAllChatRooms() {

        
        
    }
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, sender: Sender, completion: @escaping () -> Void) {
        
        guard let index = chatRooms.firstIndex(of: chatRoom) else { completion(); return }

        let newMessage = ChatRoom.Message(text: text, sender: sender)
        chatRooms[index].messages.append(newMessage)

        
        
        
//        guard let key = ref.child("Chat Rooms").childByAutoId().key else { return }
        let message = ["text": text,
                       "displayName": newMessage.displayName,
                       "senderID": newMessage.senderID,
                       "timestamp": "\(newMessage.timestamp)",
                       "messageID": newMessage.messageId] as [String : String]
//        let childUpdates = ["/posts/\(key)": post,
//                            "/user-posts/\(userID)/\(key)/": post]
        ref.child(chatRoom.identifier).child(newMessage.messageId).setValue(message)
        completion()
        

//
//        var messageId: String
//
//        var sentDate: Date {
//            return timestamp
//        }
//        var kind: MessageKind {
//            return .text(text)
//        }
//        var sender: SenderType {
//            return Sender(senderId: senderID, displayName: displayName)
//        }
        
    }
    
    func fetchAllMessages() {

        
    }
    
    
}
