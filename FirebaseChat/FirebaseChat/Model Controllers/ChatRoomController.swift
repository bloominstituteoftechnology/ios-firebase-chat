//
//  ChatRoomController.swift
//  FirebaseChat
//
//  Created by Rob Vance on 10/2/20.
//

import Foundation
import Firebase


protocol ModelControllerDelegate: AnyObject {
    func chatRoomsUpdated()
}

class ChatRoomController {
    
    weak var delegate: ModelControllerDelegate!
    let messagesRef = Database.database().reference().child("messagesByChatRoomId")
    let chatRoomsRef = Database.database().reference().child("chatRooms")
    
    var chatRooms: [ChatRoom] = [] {
        didSet {
            delegate.chatRoomsUpdated()
        }
    }
    init() {
      fetchChatRooms()
    }
    
    func fetchChatRooms() {
        chatRoomsRef.observeSingleEvent(of: .value) { snapshot in
            guard let snapDictionary = snapshot.value as? [String : [String : Any]] else { return }
            
            self.chatRooms.removeAll()
            for child in snapDictionary {
                guard let chatRoom = ChatRoom(id: child.key, dictionary: child.value) else { continue }
                self.chatRooms.append(chatRoom)
            }
        }
    }
    
    func createChatRoom(_ name: String) {
        let newChatRoom = ChatRoom(name: name)
        chatRoomsRef.child(newChatRoom.id).setValue([
        "name": newChatRoom.name
        ])
        
        fetchChatRooms()
    }
    
    func createMessageInChatRoom(message: Message, chatRoom: ChatRoom) {
        messagesRef.child(chatRoom.id).child(message.id).setValue([
            "text": message.text,
            "date": String(describing: message.date),
        ])
    }
    
    func fetchMessagesInChatRoom(_ chatRoom: ChatRoom, completion: @escaping ([Message]) -> Void) {
        messagesRef.child(chatRoom.id).observeSingleEvent(of: .value) { (snapshot) in
            guard let messagesDictionary = snapshot.value as? [String: [String : Any]] else {
                completion([])
                return
            }
            var messages: [Message] = []
            for child in messagesDictionary {
                guard let message = Message(id: child.key, dictionary: child.value) else { continue }
                messages.append(message)
            }
            completion(messages)
        }
    }
}
