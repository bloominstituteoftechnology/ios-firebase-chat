//
//  ChatRoomsController.swift
//  firebaseChats
//
//  Created by Jesse Ruiz on 11/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class ChatRoomsController {
    
    // MARK: - Properties
    static let baseURL = URL(string: "https://fir-chats-6309d.firebaseio.com/")!
    var chatRooms: [ChatRoom] = []
    var currentUser: Sender?
    
    // MARK: - Methods
    func createChatRoom(with title: String, completion: @escaping () -> Void) {
        
        let room = ChatRoom(title: title)
        
        let requestURL = ChatRoomsController.baseURL
            .appendingPathComponent(room.identifier)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(room)
        } catch {
            NSLog("Error encoding room to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with room creation in data task: \(error)")
                completion()
                return
            }
            
            self.chatRooms.append(room)
            completion()
            
        }.resume()
    }
    
    func fetchChatRooms(completion: @escaping () -> Void) {
        let requestURL = ChatRoomsController.baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching chat rooms: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task");
                completion();
                return
            }
            
            do {
                self.chatRooms = try JSONDecoder().decode([String : ChatRoom].self, from: data).map({ $0.value })
            } catch {
                self.chatRooms = []
                NSLog("Error decoding chat rooms from JSON data: \(error)")
            }
            completion()
        }.resume()
    }
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, sender: Sender, completion: @escaping () -> Void) {
        
        guard let index = chatRooms.firstIndex(of: chatRoom) else { completion(); return }
        
        let message = ChatRoom.Message(text: text, sender: sender)
        
        chatRooms[index].messages.append(message)
        
        let requestURL = ChatRoomsController.baseURL
            .appendingPathComponent(chatRoom.identifier)
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
                NSLog("Error with chat room creation in data task: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
//    func fetchMessages(completion: @escaping () -> Void) {
//
//        let requestURL = ChatRoomsController.baseURL.appendingPathExtension("json")
//
//        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
//
//            if let error = error {
//                NSLog("Error fetching messages: \(error)")
//                completion()
//                return
//            }
//
//            guard let data = data else { NSLog("No data returned from data task"); completion(); return }
//
//            do {
//
//            } catch {
//
//            }
//        }
//    }
}
