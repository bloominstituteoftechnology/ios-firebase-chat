//
//  SenderHelper.swift
//  FirebaseChat
//
//  Created by Spencer Curtis on 9/18/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import MessageKit

class SenderHelper {
    static var currentSender: Sender!
    
    static func setCurrentSender(with displayName: String) {
        currentSender = Sender(id: UUID().uuidString, displayName: displayName)
    }
}
