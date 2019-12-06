//
//  ChatRoomController.swift
//  FirebaseChat
//
//  Created by Bobby Keffury on 12/6/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import Foundation

class ChatRoomController {
    
    static let baseURL = URL(string: "https://fir-chat-9fa8f.firebaseio.com/")!
    var chatRooms: [ChatRoom] = []
    
    func createChatRoom(with title: String, completion: @escaping () -> Void) {
        let chatRoom = ChatRoom(title: title)

        let requestURL = ChatRoomController.baseURL.appendingPathComponent(chatRoom.identifier).appendingPathExtension("json")

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
    
    func createMessage() {
        
    }
    
    func fetchMessages() {
        
    }
}
