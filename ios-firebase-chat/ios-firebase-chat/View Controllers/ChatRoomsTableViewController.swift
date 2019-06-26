//
//  ChatRoomsTableViewController.swift
//  ios-firebase-chat
//
//  Created by Hector Steven on 6/25/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit

class ChatRoomsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
		
		
		return cell
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ChatRoomSegue" {
			guard let viewController = segue.destination as? MessageViewController else { return }
			
			
			
		}
	}
	
	
}
