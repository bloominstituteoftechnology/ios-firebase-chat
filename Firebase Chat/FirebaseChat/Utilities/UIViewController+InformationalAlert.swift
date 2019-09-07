//
//  UIViewController+InformationalAlert.swift
//  FirebaseChat
//
//  Created by Spencer Curtis on 9/18/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentInformationalAlertController(title: String?, message: String?, dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)
        
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: completion)
    }
}
