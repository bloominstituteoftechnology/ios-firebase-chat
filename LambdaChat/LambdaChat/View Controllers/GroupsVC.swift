//
//  GroupsVC.swift
//  LambdaChat
//
//  Created by Jeffrey Santana on 9/17/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class GroupsVC: UITableViewController {
	
	//MARK: - IBOutlets
	
	@IBOutlet weak var titleTextField: UITextField!
	
	//MARK: - Properties
	
	var chatController = ChatController()
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		titleTextField.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		chatController.fetchGroups { () in
			guard !self.chatController.groups.isEmpty else { return }
			
			self.tableView.reloadData()
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let messagesVC = segue.destination as? MessagesVC, let indexPath = tableView.indexPathForSelectedRow {
			messagesVC.group = chatController.groups[indexPath.row]
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		view.endEditing(true)
	}
	
	//MARK: - IBActions
	
	
	//MARK: - Helpers
	
	private func okAlert(title: String) {
		let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
			self.navigationController?.popViewController(animated: true)
		}))
		self.present(alert, animated: true)
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return chatController.groups.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
		
		cell.textLabel?.text = chatController.groups[indexPath.row].title
		
		return cell
	}
}

extension GroupsVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let title = textField.optionalText,
			!chatController.groups.contains(where: {$0.title.lowercased() == title.lowercased()}) else {
				okAlert(title: "This group name is invalid or already exists")
				return false
		}
		
		chatController.createGroup(with: title.capitalized) {
			self.titleTextField.text = ""
		}
		return true
	}
}
