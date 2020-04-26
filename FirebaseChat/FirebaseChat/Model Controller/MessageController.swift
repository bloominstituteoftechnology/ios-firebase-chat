//
//  MessageController.swift
//  FirebaseChat
//
//  Created by Sal B Amer on 4/26/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import Foundation

class MessageController {
    
    //baseURL
    static let baseURL = URL(string: "https://fir-dchat2.firebaseio.com/")!
    var chatThreads: [ChatThread] = []
    
    // Create Chatroom
    func createChatroom(with title: String, completion: @escaping () -> Void) {
        
    let chatroomThread = ChatThread(title: title)
        let requestURL = MessageController.baseURL.appendingPathComponent(chatroomThread.identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(chatroomThread)
        } catch {
            print("Error encoding to JSON: \(error)")
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error creating message theread: \(error)")
                completion()
                return
            }
            self.chatThreads.append(chatroomThread)
            completion()
        }.resume()
        
    }
    // Fetch Chatroom "GET"

    // Create Message in chatroom

    // Fetch Messages in chatroom

    
}


