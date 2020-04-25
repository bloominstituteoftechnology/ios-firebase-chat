//
//  Message.swift
//  firebase-chat
//
//  Created by Joe on 4/25/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import Foundation
import MessageKit

class Message {
    public enum MessageKind {
        case text(String) // TextMessageCell
        case attributedText(NSAttributedString) // TextMessageCell
        case photo(MediaItem) // MediaMessageCell
        case video(MediaItem) // MediaMessageCell
        case location(LocationItem) // LocationMessageCell
        case emoji(String) // TextMessageCell
        case audio(AudioItem) // AudioMessageCell
        case contact(ContactItem) // ContactMessageCell

        case custom(Any?)
    }
    
}


public protocol MessageType {

    var sender: Sender { get }

    var messageId: String { get }

    var sentDate: Date { get }

    var kind: MessageKind { get }
}
