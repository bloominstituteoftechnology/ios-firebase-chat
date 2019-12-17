//
//  ChatController.swift
//  Firebase Chat
//
//  Created by macbook on 11/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import MessageKit

class ChatController {
    
    static let baseURL = URL(string: "https://fir-chatwr.firebaseio.com/")!
    var chatRooms: [ChatRoom] = []
    
    var currentUser: Sender?
    
    func fetchChatRooms(completion: @escaping () -> Void) {
        
        let requestURL = ChatController.baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching chat rooms: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion()
                return
            }
            
            do {
                self.chatRooms = try JSONDecoder().decode([String: ChatRoom].self, from: data).map({ $0.value })
            } catch {
                self.chatRooms = []
                NSLog("Error decoding chat rooms from JSON data: \(error)")
            }
            completion()
        }.resume()
    }
    
    func createChatRoom(with title: String, completion: @escaping () -> Void) {
        
        let chatRoom = ChatRoom(title: title)
        
        let requestURL = ChatController.baseURL
            .appendingPathComponent(chatRoom.identifier)
            .appendingPathExtension("json")
        
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
            
//            guard let data = data else {
//                NSLog("Error decoding chatRoom data: \(error)")
//                completion()
//                return
//            }
            self.chatRooms.append(chatRoom)
            completion()
            
        }.resume()
    }
    
    func createMessage(in chatRoom: ChatRoom, with text: String, sender: Sender, completion: @escaping () -> Void) {
        
//        let message = Message(sender: sender, text: text)
        
        guard let index = chatRooms.firstIndex(of: chatRoom) else { // instead of index(depricated, I used  firstIndex
            completion()
            return }
        
        let message = Message(sender: sender, text: text)
        
        chatRooms[index].messages.append(message)
        
        let requestURL = ChatController.baseURL.appendingPathComponent(chatRoom.identifier)
                                .appendingPathComponent("messages")
                                .appendingPathExtension("json")
        
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
    
    
//    func createMessage(in messageThread: Message, withText text: String, sender: Sender, completion: @escaping () -> Void) {
//
//        guard let index = chatRooms.index(of: ChatRoom) else { completion(); return }
//
//        let message = Message(sender: sender, text: text)
//
//        chatRooms[index].messages.append(message)
//
//        let requestURL = ChatController.baseURL.appendingPathComponent(ChatRoom.id).appendingPathComponent("messages").appendingPathExtension("json")
//
//        var request = URLRequest(url: requestURL)
//
//        request.httpMethod = HTTPMethod.post.rawValue
//
//        do {
//            request.httpBody = try JSONEncoder().encode(message)
//        } catch {
//            NSLog("Error encoding message to JSON: \(error)")
//        }
//
//        URLSession.shared.dataTask(with: request) { (data, _, error) in
//
//            if let error = error {
//                NSLog("Error with message creation data task: \(error)")
//                completion()
//                return
//            }
//
//            completion()
//
//        }.resume()
//    }
}
