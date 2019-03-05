//
//  Chats.swift
//  Firebase Chat
//
//  Created by Nelson Gonzalez on 3/5/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import Firebase
import MessageKit

struct Chats {
    var name: String?
    var uid: String?
    var timeStamp: NSNumber?
    var id: String?
 //   var messages: [Message]
    
   
}

extension Chats {
    static func transformChats(dict: [String:Any], key: String) -> Chats {
        var chats = Chats()
        chats.id = key
        chats.name = dict["chat_name"] as? String
        chats.uid = dict["uid"] as? String
        chats.timeStamp = dict["timeStamp"] as? NSNumber
        return chats
    }
    
}


struct Message: MessageType {
    let chats: Chats?
    var text: String
    var displayName: String
    var senderID: String
    //  var timestamp: Date
    var messageId: String
    
    //
    //        init(text: String, sender: Sender, timestamp: Date = Date(), messageId: String = UUID().uuidString) {
    //            self.text = text
    //            self.displayName = sender.displayName
    //            self.senderID = sender.id
    //          //  self.timestamp = timestamp
    //            self.messageId = messageId
    //        }
    
    
    
    // MARK: - MessageType
    var sentDate: Date { return Date() }
    var kind: MessageKind { return .text(text) }
    var sender: Sender {
        return Sender(id: senderID, displayName: displayName)
    }
    
}



