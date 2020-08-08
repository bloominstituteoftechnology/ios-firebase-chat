//
//  MessageController.swift
//  FirebaseChat
//
//  Created by Morgan Smith on 8/7/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import Foundation

class MessageController {

    static let baseURL = URL(string: "https://fir-chat-bef63.firebaseio.com/")!
    var messageThreads: [MessageThread] = []
    var currentUser: Sender?

    func fetchMessageThreads(completion: @escaping () -> Void) {

        let requestURL = MessageController.baseURL.appendingPathExtension("json")

        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in

            if let error = error {
                NSLog("Error fetching message threads: \(error)")
                completion()
                return
            }

            guard let data = data else { NSLog("No data returned from data task"); completion(); return }

            do {
                let threads = try JSONDecoder().decode([String: MessageThread].self, from: data)
                self.messageThreads = Array(threads.values)
            } catch {
                self.messageThreads = []
                NSLog("Error decoding message threads from JSON data: \(error)")
            }

            completion()
        }.resume()
    }

    func createMessageThread(with title: String, completion: @escaping () -> Void) {

        let thread = MessageThread(title: title)

        let requestURL = MessageController.baseURL.appendingPathComponent(thread.identifier).appendingPathExtension("json")

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

        guard let index = messageThreads.firstIndex(of: messageThread) else { completion(); return }

        let message = MessageThread.Message(text: text, sender: sender)

        messageThreads[index].messages.append(message)

        let requestURL = MessageController.baseURL.appendingPathComponent(messageThread.identifier).appendingPathComponent("messages").appendingPathExtension("json")

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
