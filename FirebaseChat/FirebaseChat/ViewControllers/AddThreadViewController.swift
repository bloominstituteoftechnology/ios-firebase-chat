//
//  AddThreadViewController.swift
//  FirebaseChat
//
//  Created by Clayton Watkins on 8/12/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit

protocol ThreadCreated {
    func threadCreated()
}

class AddThreadViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var threadTitleTextField: UITextField!
    
    // MARK: - Properties
    var threadController: ThreadController?
    var delegate: ThreadCreated?
    // MARK: - IBActions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let title = threadTitleTextField.text else { return }
        threadController?.createThread(title: title, completion: {
            self.delegate?.threadCreated()
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    // MARK: - Functions

}
