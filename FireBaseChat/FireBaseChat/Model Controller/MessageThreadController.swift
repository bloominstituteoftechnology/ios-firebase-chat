//
//  MessageThreadController.swift
//  FireBaseChat
//
//  Created by Rachael Cedeno on 4/27/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//

import Foundation
import Firebase

class MessageThreadController {
    
//    static let baseURL = URL(string: "https://lambda-message-board.firebaseio.com/withframeworks")!
    static let baseURL = URL(string: "https://chatwithfirebase-d1e75.firebaseio.com/")!
    var messageThreads: [MessageThread] = []
    
    var ref: DatabaseReference! = Database.database().reference()


    func fetchMessageThreads(completion: @escaping () -> Void) {
        
        let requestURL = MessageThreadController.baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching message threads: \(error)")
                completion()
                return
            }
            
            guard let data = data else { NSLog("No data returned from data task"); completion(); return }
            
            do {
                self.messageThreads = try JSONDecoder().decode([String: MessageThread].self, from: data).map({ $0.value })
            } catch {
                self.messageThreads = []
                NSLog("Error decoding message threads from JSON data: \(error)")
            }
            
            completion()
        }.resume()
    }
    
    func createMessageThread(with title: String, completion: @escaping () -> Void) {
        
        let thread = MessageThread(title: title)
        
        let requestURL = MessageThreadController.baseURL.appendingPathComponent(thread.identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(thread)
        } catch {
            NSLog("Error encoding thread to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with message thread creation data task: \(error)")
                completion()
                return
            }
            
            self.messageThreads.append(thread)
            completion()
            
        }.resume()
    }
    
    func createMessage(in messageThread: MessageThread, withText text: String, sender: String, completion: @escaping () -> Void) {
        
        guard let index = messageThreads.firstIndex(of: messageThread) else { completion(); return }
        
        let message = MessageThread.Message(text: text, displayName: sender)
        
        messageThreads[index].messages.append(message)
        
        let requestURL = MessageThreadController.baseURL.appendingPathComponent(messageThread.identifier).appendingPathComponent("messages").appendingPathExtension("json")
        
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
