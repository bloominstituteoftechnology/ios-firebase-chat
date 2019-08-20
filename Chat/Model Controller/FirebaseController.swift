//
//  ChatRoomController.swift
//  Chat
//
//  Created by Kat Milton on 8/20/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation

class FirebaseController {
    
    func createChatRoom(with title: String, completion: @escaping () -> Void) {
        let chatRoom = ChatRoom(title: title)
        let requestURL = FirebaseController.baseURL.appendingPathComponent(chatRoom.identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(chatRoom)
        } catch {
            NSLog("Error encoding thread to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with message thread creation data task: \(error)")
                completion()
                return
            }
            
            self.chatRooms.append(chatRoom)
            completion()
            
            }.resume()
    }
    
    func fetchChatRooms(completion: @escaping () -> Void) {
        
        let requestURL = FirebaseController.baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching chat rooms: \(error)")
                completion()
                return
            }
            
            guard let data = data else { NSLog("No data returned from data task")
                completion()
                return }
            
            do {
                self.chatRooms = try JSONDecoder().decode([String: ChatRoom].self, from: data).map({ $0.value })
            } catch {
                self.chatRooms = []
                NSLog("Unknown error decoding chat rooms from JSON data")
            }
            
            completion()
            }.resume()
    }
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, sender: Sender, completion: @escaping () -> Void) {
        
        guard let index = chatRooms.firstIndex(of: chatRoom) else { completion(); return }
        let message = ChatRoom.Message(text: text, sender: sender)
        
        chatRooms[index].messages.append(message)
        
        let requestURL = FirebaseController.baseURL.appendingPathComponent(chatRoom.identifier).appendingPathComponent("messages").appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "POST"
        
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
    
    
    static let baseURL = URL(string: "https://chatforcoolkids.firebaseio.com/")!
    var chatRooms: [ChatRoom] = []
    var currentUser: Sender?
    
}
