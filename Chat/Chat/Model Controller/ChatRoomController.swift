//
//  ChatRoomController.swift
//  Chat
//
//  Created by Chris Dobek on 5/21/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit
import MessageKit


class ChatRoomController {
    
    static let baseURL = URL(string: "https://fir-chat-b0f58.firebaseio.com/")!
    var chatRooms: [ChatRoom] = []
    var currentUser: Sender? {
        didSet {
            UserDefaults.standard.set(currentUser?.dictionaryRepresentation, forKey: "currentUser")
        }
    }
    
    init() {
        if let currentUserDictionary = UserDefaults.standard.value(forKey: "currentUser") as? [String : String], let currentUser = Sender(dictionary: currentUserDictionary) {
            self.currentUser = currentUser
        }
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
    
    func createChatRoom(with title: String, completion: @escaping () -> Void) {
        
        let chat = ChatRoom(title: title)
        
        let requestURL = ChatRoomController.baseURL.appendingPathComponent(chat.identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(chat)
        } catch {
            NSLog("Error encoding thread to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with message thread creation data task: \(error)")
                completion()
                return
            }
            
            self.chatRooms.append(chat)
            completion()
            
        }.resume()
    }
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, completion: @escaping () -> Void) {
        
        guard let index = chatRooms.firstIndex(of: chatRoom), let sender = currentUser else { completion(); return }
        
        let message = ChatRoom.Message(text: text, sender: sender)
        
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

