//
//  FirebaseController.swift
//  Firebase Chat
//
//  Created by Mitchell Budge on 6/25/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import Foundation

class FirebaseController {
    
    func createChatRoom(with title: String, completion: @escaping () -> Void) {
        let chatRoom = ChatRoom(title: title)
        let requestURL = FirebaseController.baseURL.appendingPathComponent(chatRoom.identifier).appendingPathExtension("json")
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
    
    func fetchChatRooms(completion: @escaping () -> Void) {
        let requestURL = FirebaseController.baseURL.appendingPathExtension("json")
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
                self.chatRooms = []
                NSLog("Error decoding chat rooms from JSON data: \(error)")
            }
            completion()
        }.resume()
    }
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, sender: Sender, completion: @escaping () -> Void) {
        guard let index = chatRooms.firstIndex(of: chatRoom) else { completion(); return }
        let message = Message(text: text, sender: sender)
        chatRooms[index].messages.append(message)
        let requestURL = FirebaseController.baseURL.appendingPathComponent(chatRoom.identifier).appendingPathComponent("messages").appendingPathExtension("json")
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
    
//    func fetchMessages() {
//        let requestURL = FirebaseController.baseURL.appendingPathComponent("messages").appendingPathExtension("json")
//        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
//            if let error = error {
//                NSLog("Error fetching chat rooms: \(error)")
//                completion()
//                return
//            }
//            guard let data = data else { NSLog("No data returned from data task"); completion(); return }
//            do {
//                self.messages = try JSONDecoder().decode([String: Message].self, from: data).map({ $0.value })
//            } catch {
//                self.messages = []
//                NSLog("Error decoding chat rooms from JSON data: \(error)")
//            }
//            completion()
//        }.resume()
//    }
    
    static let baseURL = URL(string: "https://fir-chat-72ca5.firebaseio.com/")!
    var chatRooms: [ChatRoom] = []
}
