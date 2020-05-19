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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions & Methods
    @IBAction func addNewConversationButtonPressed(_ sender: UIButton) {
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destination.
//         Pass the selected object to the new view controller.
    }

}

extension ConversationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
