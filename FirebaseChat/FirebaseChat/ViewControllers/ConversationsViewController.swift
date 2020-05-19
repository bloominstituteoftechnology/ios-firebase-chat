//
//  ConversationsViewController.swift
//  FirebaseChat
//
//  Created by Shawn James on 5/19/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class ConversationsViewController: UIViewController {

    // MARK: - Outlets & Properties
    @IBOutlet weak var newConversationTitleTextField: UITextField!
    let modelController = ModelController()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions & Methods
    @IBAction func addNewConversationButtonPressed(_ sender: UIButton) {
        guard let name = newConversationTitleTextField.text, !name.isEmpty else { return }
        modelController.addNewConversation(named: name)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destination.
//         Pass the selected object to the new view controller.
    }

}

// MARK: - TableView data source
extension ConversationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 0 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
    
}
