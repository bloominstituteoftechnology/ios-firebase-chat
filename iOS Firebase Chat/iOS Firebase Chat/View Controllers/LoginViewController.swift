//
//  LoginViewController.swift
//  iOS Firebase Chat
//
//  Created by Dillon McElhinney on 2/12/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    // MARK: - Properties
    var authHandle: AuthStateDidChangeListenerHandle!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        resetTextFields()
        authHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("\(user.displayName ?? "no name") - \(user.email ?? "no email") is logged in.")
                self.performSegue(withIdentifier: "LoginSegue", sender: self)
            } else {
                print("Not logged in.")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(authHandle!)
    }
    
    // MARK: - UI Actions
    @IBAction func signupNewUser(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: authorizationCompletion)
    }
    
    @IBAction func loginExistingUser(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: authorizationCompletion)
    }
    
    // MARK: - Utility Methods
    private func resetTextFields() {
        errorLabel.text = nil
        emailTextField.text = nil
        passwordTextField.text = nil
    }
    
    private func authorizationCompletion(result: AuthDataResult?, error: Error?) {
        if let error = error {
            let error = error as NSError
            self.updateErrorLabel(with: error.code)
        }
    }
    
    private func updateErrorLabel(with errorCode: Int) {
        var message = "Something has gone wrong."
        switch errorCode {
            
        case 17007: message = "Someone's already using that email address."
        case 17009: message = "That looks like the wrong password."
        case 17011: message = "It doesn't look like there is a user with that email."
        default : break
        }
        errorLabel.text = message
    }
    
}
