//
//  ChatRoomController.swift
//  FirebaseChat
//
//  Created by Cody Morley on 6/16/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import MessageKit

struct ChatRoomController {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    
    private var baseURL = URL(string: "https://fir-chat-c0a6f.firebaseio.com/")
    private var jsonEncoder: JSONEncoder {
        return JSONEncoder()
    }
    private var jsonDecoder: JSONDecoder {
        return JSONDecoder()
    }
    var room: Room?
    
    
    init(with room: Room) {
        self.room = room
    }
    
    
    func createChatRoom() {
        
    }
    
    func createMessage() {
        
    }
    
    func fetchRooms() {
        
    }
    
    func fetchMessages() {
        
    }
    
}
