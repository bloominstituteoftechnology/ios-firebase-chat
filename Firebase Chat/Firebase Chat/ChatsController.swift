//
//  ChatsController.swift
//  Firebase Chat
//
//  Created by Nelson Gonzalez on 3/5/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import Firebase
import MessageKit

class ChatsController {
    
    var chatrooms: [Chats] = []
    var messages: [Message] = []
    
    var currentUser: Sender?
    
    var chatsRef = Database.database().reference().child("chats")
    var messagesRef = Database.database().reference().child("messages")
    var messagesPostRef = Database.database().reference().child("my-messages")
    var chatsPostRef = Database.database().reference().child("chat-rooms")
    var refMyChats = Database.database().reference().child("myChats")
    
    func observeChats(withChatId id: String, completion: @escaping (Chats)-> Void){
        chatsRef.child(id).observe(.value) { (snapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                let newChats = Chats.transformChats(dict: dict, key: snapshot.key)
                completion(newChats)
            }
            
        }
        
    }
    
    func uploadDataToServer(chatName: String, onSuccess: @escaping () -> Void){
        
                    sendDataToDatabase(chatName: chatName, onSuccess: onSuccess)

    }
    
   func sendDataToDatabase(chatName: String, onSuccess: @escaping ()->Void){
        
        let newChatId = chatsRef.childByAutoId().key
        let newChatReference = chatsPostRef.child(newChatId!)
        
        var chat = Chats()
        
        chat.timeStamp = Date().timeIntervalSince1970 as NSNumber
        
        guard let currentUser = Auth.auth().currentUser else {return}
        
        let currentUserId = currentUser.uid
        //push to database
        newChatReference.setValue(["uid": currentUserId, "chat_name": chatName, "timeStamp": chat.timeStamp!]) { (error, ref) in
            if error != nil {
                print("Error posting to database: \(error!.localizedDescription)")
                return
            }
            
            
            let myChatsRef = self.refMyChats.child(currentUserId).child(newChatId!)
            myChatsRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
            })
            
            onSuccess()
        }
    }
    
    
    func observeChatRooms(completion: @escaping (Chats) -> Void){
        chatsPostRef.observe(.childAdded) { (snapshot) in
            //receive a dataSnapshot which contains data
            if let dict = snapshot.value as? [String: Any] {
                let newChats = Chats.transformChats(dict: dict, key: snapshot.key)
                //execute whatever we want after we have a posts instance
                self.chatrooms.append(newChats)
                completion(newChats)//outsiders can use this newPosts cause of the escaping clousure.
                
            }
        }
    }
    
  
    
    func sendMessageToDatabase(chat: Chats?, id: String, text: String, onSuccess: @escaping ()->Void){
        
        let newChatId = messagesRef.childByAutoId().key
        let newChatReference = messagesPostRef.child(newChatId!)
        
      //  var chat = Chats()
      //  let messages = Message(chats: chat, text: text, displayName: (chat?.uid)!, senderID: (chat?.uid!)!, messageId: newChatId!)
        
        
      //  chat?.timeStamp = Date().timeIntervalSince1970 as NSNumber
        let timeStamp = Date().timeIntervalSince1970 as NSNumber
        
        guard let currentUser = Auth.auth().currentUser else {return}
        
        let currentUserId = currentUser.uid
        //push to database
        newChatReference.setValue(["uid": currentUserId, "text": text, "timeStamp": timeStamp]) { (error, ref) in
            if error != nil {
                print("Error posting to database: \(error!.localizedDescription)")
                return
            }
            
            onSuccess()
        }
    }
    
    
    func uploadMessagesToServer(chat: Chats?, id: String, text: String, onSuccess: @escaping () -> Void){
        
        sendMessageToDatabase(chat: chat, id: id, text: text) {
            onSuccess()
        }
        
    }
    
    
}
