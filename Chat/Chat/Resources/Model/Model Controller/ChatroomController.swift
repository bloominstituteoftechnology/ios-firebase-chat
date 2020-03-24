//
//  ChatroomController.swift
//  Chat
//
//  Created by Nick Nguyen on 3/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation

enum HTTPMethod : String  {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class ChatroomController {
    
    let baseURL = URL(string: "https://chat-e1efa.firebaseio.com/")!
    
    var chatrooms : [Chatroom] = []
    
    
    func createChatroom(with name: String, roomPurpose: String, completion: @escaping () -> Void  ) {
        let newChatRoom = Chatroom(name: name, roomPurpose: roomPurpose)
        chatrooms.append(newChatRoom)
        
        let createChatroomURL = baseURL.appendingPathComponent(newChatRoom.id)
        .appendingPathComponent("chatrooms")
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
}
