//
//  ChatroomController.swift
//  Chat
//
//  Created by Nick Nguyen on 3/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum HTTPMethod : String  {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class ChatroomController {
   

    private let roomsRef = Database.database().reference().child("rooms")
    
    let baseURL = URL(string: "https://chat-e1efa.firebaseio.com/")!
    
    var chatrooms : [Chatroom] = []
    var messageThreads: [MessageThread] = []
    var currentUser: Sender?
    
    func createChatroom(with name: String, roomPurpose: String, completion: @escaping () -> Void  ) {
        let newChatRoom = Chatroom(name: name, roomPurpose: roomPurpose)
      
        chatrooms.append(newChatRoom)
        
        let createChatroomURL = baseURL.appendingPathComponent("chatrooms")
                 .appendingPathExtension("json")
        
         
        
        var request = URLRequest(url: createChatroomURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(newChatRoom)
        } catch let err as NSError {
            NSLog(err.localizedDescription)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error creating chatrooms: \(error)" )
                completion()
                return
            }
            completion()
        }.resume()
        
    }
    
    
    
    func fetchChatroomsFromSever(completion: @escaping () -> Void) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching chatrooms: \(error)")
                completion()
                return
            }
            
            guard let data = data else { NSLog("No data returned from data task"); completion(); return }
            
            do {
                let dataFromSever =  try JSONDecoder().decode([String:[String:Chatroom]].self, from: data)
                let  chatroomDict = dataFromSever["chatrooms"]!
                let chatroomArray = Array(chatroomDict.values)
                self.chatrooms = chatroomArray
              
                self.chatrooms.forEach { (room) in
                    print(room.name)
                }
                
            } catch {
                self.chatrooms = []
                NSLog("Error decoding chatrooms from JSON data: \(error)")
            }
                
            completion()
        }.resume()
    }
    
    func createMessageThread(with title: String, completion: @escaping () -> Void) {
        
        let thread = MessageThread(title: title)
        
        let requestURL = baseURL.appendingPathComponent(thread.identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(thread)
        } catch {
            NSLog("Error encoding thread to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with message thread creation data task: \(error)")
                completion()
                return
            }
            
            self.messageThreads.append(thread)
            completion()
            
        }.resume()
    }
    
    func createMessage(in messageThread: MessageThread, withText text: String, sender: Sender, completion: @escaping () -> Void) {
        
        guard let index = messageThreads.firstIndex(of: messageThread) else { completion(); return }
        
        let message = MessageThread.Message(text: text, sender: sender)
        
        messageThreads[index].messages.append(message)
        
        let requestURL = baseURL.appendingPathComponent(messageThread.identifier).appendingPathComponent("messages").appendingPathExtension("json")
        
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
