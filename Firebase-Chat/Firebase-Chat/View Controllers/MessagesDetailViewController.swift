//
//  MessageDetailViewController.swift
//  Firebase-Chat
//
//  Created by Marlon Raskin on 9/18/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessagesDetailViewController: MessagesViewController {

	let messagesController = MessageController()

    override func viewDidLoad() {
        super.viewDidLoad()
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
		messageInputBar.delegate = self
    }

}

extension MessagesDetailViewController: MessagesDataSource {

	func currentSender() -> SenderType {
		guard let user = messagesController.currentUser else { fatalError("No user set")  }
		return user
	}

	func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
		let message = messagesController.messages[indexPath.item]
		
		return message
	}

	func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
		return 1
	}

	func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
		<#code#>
	}
}

extension MessagesDetailViewController: MessagesDisplayDelegate {

}

extension MessagesDetailViewController: InputBarAccessoryViewDelegate {

}

extension MessagesDetailViewController: MessagesLayoutDelegate {

}
