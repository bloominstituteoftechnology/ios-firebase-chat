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
    var chatRoomRepresentations: [ChatRoomRepresentation] = []
    var currentUser: Sender? = K.testUser
    
    var ref: DatabaseReference!
//    var refMessageHandle: DatabaseHandle!
//    var refChatRoomHandle: DatabaseHandle!
    
    // MARK: Methods

    func fetchChatRooms(completion: @escaping () -> Void) {
        // TODO: Test fetchChatRooms()
        ref.child("chatRooms").observeSingleEvent(of: .value) { snapshot in
            if let chatRoomsDict = snapshot.value as? [String : [String: String]] {
                self.updateChatRooms(from: chatRoomsDict)
            }
            completion()
        }
    }
    
    func fetchMessages(in chatRoom: ChatRoom, completion: @escaping () -> Void) {
        // TODO: Test fetchMessages()
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
        // TODO: Test createMessage()
        let message = Message(text: text, sender: sender)
        chatRoom.messages.append(message)
        self.ref.child("messages").child(chatRoom.id).child("messages").setValue([message.messageID: message])
        completion()
    }
    
    // MARK: - Initializers

    init() {
        self.ref = Database.database().reference()
    }
    
    // MARK: - Helpers

    func updateChatRooms(from chatRoomsDict: [String: [String: String]]) {
        chatRooms = arrayFromNestedDictionary(dictionary: chatRoomsDict)
    }
    
    func updateMessages(in chatRoom: ChatRoom, from messagesDict: [String: [String: String]]) {
        chatRoom.messages = arrayFromNestedDictionary(dictionary: messagesDict)
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

