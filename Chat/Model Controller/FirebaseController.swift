//
//  ChatRoomController.swift
//  Chat
//
//  Created by Kat Milton on 8/20/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseController {
    
    init() {
        
        ref = Database.database().reference()
    }
    
    func observeChatRooms(withChatId id: String, completion: @escaping (ChatRoom)-> Void){
        
        ref.child("chatRoom").observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newChatRoom = ChatRoom.transformChatroomToDictionary(dict: dict, key: snapshot.key)
                completion(newChatRoom)
            }
        }
    }
    
    func uploadDataToServer(chatRoomName: String, onSuccess: @escaping () -> Void){
        sendDataToDatabase(chatRoomName: chatRoomName, onSuccess: onSuccess)
    }
    
    func sendDataToDatabase(chatRoomName: String, onSuccess: @escaping ()->Void){
        
        let newChatroomId = ref?.childByAutoId().key
        let newChatroomRef = ref?.child(newChatroomId!)
        
        var chatroom = ChatRoom()
        
        chatroom.timeStamp = Date().timeIntervalSince1970 as NSNumber
        
        guard let currentUser = self.currentUser else {return}
        
        let currentUserId = currentUser.senderId
        //push to database
        newChatroomRef?.setValue(["senderId": currentUserId, "chatRoom": chatRoomName, "timeStamp": chatroom.timeStamp!]) { (error, ref) in
            if error != nil {
                print("Error posting to database: \(error!.localizedDescription)")
                return
            }
            
            var refMyChatRooms = Database.database().reference().child("myChatRooms")
            let chatroomRef = refMyChatRooms.child(currentUserId).child(newChatroomId!)
            chatroomRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
            })
            onSuccess()
        }
    }
    
    
    func observeChatRooms(completion: @escaping (ChatRoom) -> Void){
        var chatsPostRef = Database.database().reference().child("chatRooms")
        chatsPostRef.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newChats = ChatRoom.transformChatroomToDictionary(dict: dict, key: snapshot.key)
                self.chatRooms.append(newChats)
                completion(newChats)
            }
        }
    }
    
    func sendMessageToDatabase(chatRoom: ChatRoom?, displayName: String, id: String, text: String, onSuccess: @escaping ()->Void){
        var messagesRef = Database.database().reference().child("messages")
        var myMessagesPostRef = Database.database().reference().child("myMessages")
        let newChatroomId = messagesRef.childByAutoId().key
        let newChatroomRef = myMessagesPostRef.child(newChatroomId!)
        let timeStamp = Date().timeIntervalSince1970 as NSNumber
        
        guard let currentUser = self.currentUser else {return}
        let currentUserId = currentUser.senderId
        
        newChatroomRef.setValue(["displayName": displayName,"senderId": currentUserId, "text": text, "timeStamp": timeStamp]) { (error, ref) in
            if error != nil {
                print("Error posting to database: \(error!.localizedDescription)")
                return
            }
            onSuccess()
        }
    }
    
    
    func uploadMessagesToServer(chatRoom: ChatRoom?, displayName: String, id: String, text: String, onSuccess: @escaping () -> Void){
        sendMessageToDatabase(chatRoom: chatRoom, displayName: displayName, id: id, text: text) {
            onSuccess()
        }
    }
    
    static let baseURL = URL(string: "https://chatforcoolkids.firebaseio.com/")!
    var chatRooms: [ChatRoom] = []
    var messages: [Message] = []
    var currentUser: Sender?
    var ref: DatabaseReference!
}



