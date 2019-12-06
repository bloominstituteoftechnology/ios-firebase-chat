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
        
    }
    
    func fetchChatRooms(completion: @escaping () -> Void) {
        
    }
    
    func createMessage() {
        
    }
    
    func fetchMessages() {
        
    }
}
