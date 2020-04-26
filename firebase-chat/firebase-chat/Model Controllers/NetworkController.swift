//
//  NetworkController.swift
//  firebase-chat
//
//  Created by Joe on 4/25/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import Foundation

class NetworkController {
    
     static let baseURL = URL(string: "https://fir-chat-bbed5.firebaseio.com/")!
    
    var messageThreads: [MessageThread] = []

    func fetchMessageThreads(completion: @escaping () -> Void) {
        
       let requestURL = NetworkController.baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching message threads: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task"); completion()
                return
                
            }
            
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
        
        let requestURL = NetworkController.baseURL.appendingPathComponent(thread.identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "PUT"
        
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
        
       guard let index = messageThreads.index(of: messageThread) else { completion(); return }
        
        let message = MessageThread.Message(text: text, displayName: sender)
        
        messageThreads[index].messages.append(message)
        
        let requestURL = NetworkController.baseURL.appendingPathComponent(messageThread.identifier).appendingPathComponent("messages").appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "POST"
        
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

