//
//  ChatRoomController.swift
//  Firebase Chat
//
//  Created by David Wright on 4/24/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import MessageKit
import Firebase

class ChatRoomController {
    
    // MARK: Properties

    var chatRooms: [ChatRoom] = []
    var currentUser: Sender? = K.testUser
    
    var ref: DatabaseReference!
    
    // MARK: Methods

    func fetchChatRooms(completion: @escaping () -> Void) {
        ref.child("chatRooms").observeSingleEvent(of: .value) { snapshot in
            if let chatRoomsDict = snapshot.value as? [String : [String: String]] {
                self.updateChatRooms(from: chatRoomsDict)
            }
            completion()
        }
    }
    
    func fetchMessages(in chatRoom: ChatRoom, completion: @escaping () -> Void) {
        ref.child("messages/chatRooms").child(chatRoom.id).child("messages").observeSingleEvent(of: .value) { snapshot in
            if let messagesDict = snapshot.value as? [String : [String: String]] {
                self.updateMessages(in: chatRoom, from: messagesDict)
            }
        }
    }
    
    func createChatRoom(titled title: String, completion: @escaping () -> Void) {
        let chatRoom = ChatRoom(title: title)
        chatRooms.append(chatRoom)
        self.ref.child("chatRooms").child(chatRoom.id).setValue(chatRoom.dictionary())
        completion()
    }
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, from sender: Sender, completion: @escaping () -> Void) {
        let message = Message(text: text, sender: sender)
        chatRoom.messages.append(message)
        self.ref.child("messages/chatRooms").child(chatRoom.id).child("messages").child(message.messageID).setValue(message.dictionary())
        completion()
    }
    
    // MARK: - Initializers

    init() {
        self.ref = Database.database().reference()
    }
    
    // MARK: - Helpers

    func updateChatRooms(from chatRoomsDict: [String: [String: String]]) {
        let chatRooms: [ChatRoom] = arrayFromNestedDictionary(dictionary: chatRoomsDict)
        self.chatRooms = chatRooms.sorted { $0.title < $1.title }
    }
    
    func updateMessages(in chatRoom: ChatRoom, from messagesDict: [String: [String: String]]) {
        let messages: [Message] = arrayFromNestedDictionary(dictionary: messagesDict)
        chatRoom.messages = messages.sorted { $0.timestamp > $1.timestamp }
    }
    
    func arrayFromNestedDictionary<T: DictionaryConvertable>(dictionary: [String: [String: String]]) -> [T] {
        var result = [T]()
        for nestedDict in dictionary.values {
            let instanceOfT = T(dictionary: nestedDict)
            result.append(instanceOfT)
        }
        return result
    }
}

