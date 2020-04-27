//
//  ChatRoomController.swift
//  FirebaseChat
//
//  Created by Jessie Ann Griffin on 4/26/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import Foundation
import MessageKit
import FirebaseDatabase

class ChatRoomController {
    
    static let baseURL = URL(string: "https://fir-chatiospt4.firebaseio.com/")!
    var chatRooms: [ChatRoom] = []
    var ref: DatabaseReference!
//    ref = Database.database().reference()

    func fetchChatRooms(completion: @escaping () -> Void) {
        
        let requestURL = ChatRoomController.baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching message threads: \(error)")
                completion()
                return
            }
            
            guard let data = data else { NSLog("No data returned from data task"); completion(); return }
            
            do {
                self.chatRooms = try JSONDecoder().decode([String: ChatRoom].self, from: data).map({ $0.value })
            } catch {
                self.chatRooms = []
                NSLog("Error decoding message threads from JSON data: \(error)")
            }
            completion()
        }.resume()
    }
    
    func createChatRoom(with title: String, completion: @escaping () -> Void) {
        
        let chatRoom = ChatRoom(title: title)
        
        let requestURL = ChatRoomController.baseURL.appendingPathComponent(chatRoom.identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.put.rawValue
        
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
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, sender: String, completion: @escaping () -> Void) {
        
        guard let index = chatRooms.firstIndex(of: chatRoom) else { completion(); return }
        
        let message = Message(text: text, displayName: sender)
        
        chatRooms[index].messages.append(message)
        
        let requestURL = ChatRoomController.baseURL.appendingPathComponent(chatRoom.identifier).appendingPathComponent("messages").appendingPathExtension("json")
        
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
