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

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if self.chatroomController.currentUser == nil {
			self.presentUsernameSubmissionAlert()
		}
	}

	private func presentUsernameSubmissionAlert() {
		let alert = UIAlertController(title: "Enter a username:", message: "WHO ARE YOU?!", preferredStyle: .alert)
		var userTextField: UITextField!
		alert.addTextField { (textField) in
			textField.placeholder = "I'm Mr. Meeseeks! Look at me!"
			userTextField = textField
		}
		let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
			guard let username = userTextField.text, !username.isEmpty else { return }
			let defaultSender = User(id: UUID(), displayName: username)
			User.setDefault(sender: defaultSender)
		}
		alert.addAction(submitAction)
		present(alert, animated: true)
	}

	@IBAction func createNewChatroomTopicFinished(_ sender: UITextField) {
		sender.resignFirstResponder()
		guard let newTopic = sender.text else { return }
		sender.text = ""
		chatroomController.createChatroom(topic: newTopic)
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
