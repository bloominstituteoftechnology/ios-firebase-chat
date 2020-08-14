//
//  ThreadTableViewController.swift
//  FirebaseChat
//
//  Created by Clayton Watkins on 8/12/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit

class ThreadTableViewController: UITableViewController {
    
    // MARK: - Properties
    let threadController = ThreadController()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threadController.threads.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThreadCell", for: indexPath)
        
        cell.textLabel?.text = threadController.threads[indexPath.row].threadTitle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "CreateThreadSegue" {
            guard let addVC = segue.destination as? AddThreadViewController else { return }
            addVC.delegate = self
            addVC.threadController = threadController
        }
        // Pass the selected object to the new view controller.
    }
    
}

// MARK: - Extension

extension ThreadTableViewController: ThreadCreated{
    func threadCreated() {
        self.tableView.reloadData()
    }
}
