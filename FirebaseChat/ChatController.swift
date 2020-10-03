//
//  ChatController.swift
//  FirebaseChat
//
//  Created by Kenneth Jones on 10/2/20.
//

import Foundation
import Firebase

class ChatController {
    
    var ref: DatabaseReference = Database.database().reference()
    
    static let baseURL = URL(string: "https://lambda-message-board.firebaseio.com/withframeworks")!
    var chats: [ChatRoom] = []
    var currentUser: Sender?

    func fetchChats(completion: @escaping () -> Void) {
        
        ref.child("chats").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [ChatRoom] else { return }
            
            self.chats = value
        }
        
        completion()
    }
    
    func createChat(with title: String, completion: @escaping () -> Void) {
        
        let chat = ChatRoom(title: title)
        
        ref.child("chats").setValue(chat)
        
        completion()
    }
    
    func fetchMessages(for chat: ChatRoom, completion: @escaping () -> Void) {
        ref.child("messages").observe(.value) { (snapshot) in
            guard let value = snapshot.value as? [Message] else { return }
            
            
        }
    }
    
    func createMessage(in chat: ChatRoom, withText text: String, sender: Sender, completion: @escaping () -> Void) {
        
        guard let index = chats.firstIndex(of: chat) else { completion(); return }
        
        let message = Message(text: text, sender: sender)
        
        chats[index].messages.append(message)
        
        let requestURL = ChatController.baseURL.appendingPathComponent(chat.identifier).appendingPathComponent("messages").appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(message)
        } catch {
            NSLog("Error encoding message to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with message thread creation data task: \(error)")
                completion()
                return
            }
            
            completion()
            
        }.resume()
    }
}
