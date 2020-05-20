//
//  MessageThreadTableViewController.swift
//  Chat
//
//  Created by Chris Dobek on 5/20/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

class MessageThreadTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    @IBOutlet var threadTitleTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: - Actions
    @IBAction func createThread(_ sender: Any) {
        threadTitleTextField.resignFirstResponder()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageThreadCell", for: indexPath)

        // Configure the cell...

        return cell
    }

  
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ViewMessageThread" {
//                   guard let indexPath = tableView.indexPathForSelectedRow,
//                       let destinationVC = segue.destination as? MessageViewController else { return }
    }
   

}
