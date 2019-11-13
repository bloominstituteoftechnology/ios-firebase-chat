//
//  ChatController.swift
//  Firebase Chat
//
//  Created by macbook on 11/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import MessageKit

struct ChatController {
    
    static let baseURL = URL(string: "")!
    var chatRooms: [ChatRoom] = []
    
    var currentUser: Sender?
    
    mutating func fetchChatRooms(completion: @escaping () -> Void) {
        
        let requestURL = ChatController.baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching chat rooms: \(error)")
                completion()
                return
            }
            
            guard let data = data else { NSLog("No data returned from data task"); completion(); return }
            
            do {
                self.chatRooms = try JSONDecoder().decode([String: ChatRoom].self, from: data).map({ $0.value })
            } catch {
                chatRooms = []
                NSLog("Error decoding message chat rooms from JSON data: \(error)")
            }
            
            completion()
        }.resume()
    }
    
    func createChatRoom(with text: String, completion: @escaping () -> Void) {
        
        let chatRoom = ChatRoom()
        
        let requestURL = ChatController.baseURL.appendingPathComponent(ChatRoom.id).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(chatRoom)
        } catch {
            NSLog("Error encoding chat room to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with chat room creation data task: \(error)")
                completion()
                return
            }
            
            self.chatRooms.append(chatRoom)
            completion()
            
        }.resume()
    }
    
    func createMessage(in messageThread: Message, withText text: String, sender: Sender, completion: @escaping () -> Void) {
        
        guard let index = chatRooms.index(of: ChatRoom) else { completion(); return }
        
        let message = Message(sender: sender, text: text)
        
        chatRooms[index].messages.append(message)
        
        let requestURL = ChatController.baseURL.appendingPathComponent(ChatRoom.id).appendingPathComponent("messages").appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(message)
        } catch {
            NSLog("Error encoding message to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with message creation data task: \(error)")
                completion()
                return
            }
            
            completion()
            
        }.resume()
    }
    
}
