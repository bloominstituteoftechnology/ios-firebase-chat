//
//  AddThreadViewController.swift
//  FirebaseChat
//
//  Created by Clayton Watkins on 8/12/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit

class AddThreadViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var threadTitleTextField: UITextField!
    
    // MARK: - Properties
    
    // MARK: - IBActions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - Functions

}
