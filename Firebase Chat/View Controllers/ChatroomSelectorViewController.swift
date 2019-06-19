//
//  ViewController.swift
//  Firebase Chat
//
//  Created by Michael Redig on 6/18/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class ChatroomSelectorViewController: UITableViewController {
	let chatroomController = ChatroomController()

	override func viewDidLoad() {
		super.viewDidLoad()
		chatroomController.monitorChatrooms { [weak self] (updatedRows) in
			self?.tableView.beginUpdates()
			let indexPaths = updatedRows.map { IndexPath(row: $0, section: 0) }
			self?.tableView.insertRows(at: indexPaths, with: .automatic)
			self?.tableView.endUpdates()
		}
	}
}

// MARK: - TableView Stuff
extension ChatroomSelectorViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return chatroomController.chatrooms.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ChatroomCell", for: indexPath)

		cell.textLabel?.text = chatroomController.chatrooms[indexPath.row].topic
		return cell
	}
}
