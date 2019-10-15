//
//  MeassageThreadController.swift
//  FirebaseChat
//
//  Created by Jake Connerly on 10/15/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation

class MessageThreadController {
    
    static let baseURL = URL(string: "https://fir-chat-9652f.firebaseio.com/")!
    var messageThreads: [MessageThread] = []
    var currentUser: Sender?

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
    
    func createMessage(in messageThread: MessageThread, withText text: String, sender: Sender, completion: @escaping () -> Void) {
        
        guard let index = messageThreads.index(of: messageThread) else { completion(); return }
        
        let message = MessageThread.Message(text: text, sender: sender)
        
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
