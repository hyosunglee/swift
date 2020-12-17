//
//  ResultViewController.swift
//  Pray111_beta_0.2
//
//  Created by vlm on 2020/12/14.
//  Copyright © 2020 vlm. All rights reserved.
//

import UIKit
import AuthenticationServices

class ResultViewController: UIViewController {
    
    
    @IBOutlet weak var userIdentifierLabel: UITextField!
    @IBOutlet weak var nickName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIdentifierLabel.text = KeychainItem.currentUserIdentifier
    }
    
    @IBAction func signOutButtonPressed() {
        // For the purpose of this demo app, delete the user identifier that was previously stored in the keychain.
        KeychainItem.deleteUserIdentifierFromKeychain()
        
        // Clear the user interface.
        userIdentifierLabel.text = ""
        nickName.text = ""
        
        // Display the login controller again.
        DispatchQueue.main.async {
            self.showLoginViewController()
        }
    }
}
