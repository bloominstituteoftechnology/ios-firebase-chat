//
//  Firebase.swift
//  ios-firebase-chat
//
//  Created by Austin Cole on 2/12/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

enum ItemTypes: String {
    case message
    case chatRoom
}

import Foundation

class Firebase<DecodableItem: Decodable> {
    typealias CompletionHandler = (Error?) -> Void
    
    func fetchItems(itemType: ItemTypes, completion: @escaping CompletionHandler) {
        let itemTypeURL = baseURL?.appendingPathComponent(itemType.rawValue)
        let requestURL = itemTypeURL?.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL!) { (data, _, error) in
            if let error = error {
                NSLog("Error performing fetching dataTask.")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("Error getting data.")
                completion(error)
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let results = try jsonDecoder.decode([String: DecodableItem].self, from: data)
                switch itemType {
                case .chatRoom:
                    self.chatRooms = results.map{ $0.value } as! [ChatRoom]
                case .message:
                    self.messages = results.map{ $0.value } as! [Message]
                }
            } catch {
                NSLog("Error decoding data.")
                completion(error)
                return
            }
        }.resume()
    }
    
    func createItems(chatRoom: ChatRoom?, identifier: String, itemType: ItemTypes, completion: @escaping CompletionHandler) {
        var requestURL: URL
        switch itemType {
        case .message:
            requestURL = (baseURL?.appendingPathComponent((chatRoom?.title)!).appendingPathComponent(identifier))!
        case .chatRoom:
            requestURL = (baseURL?.appendingPathComponent(identifier))!
        }
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error performing creation dataTask.")
                completion(error)
                return
        }
        }
    }
    
    let baseURL = URL(string: "https://ios-firebase-chat-cde5a.firebaseio.com/")
    var chatRooms: [ChatRoom]?
    var messages: [Message]?
}

