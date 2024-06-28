//
//  LoginValidation.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 27/6/24.
//

import UIKit

class LoginValidation {
    
    static func validate(_ observer: UIViewController, username: String, password: String, message: String = "Username and password can't be empty!") -> Bool {
        let alertController = UIAlertController(title: "Error", message: message , preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive)
        alertController.addAction(alertAction)
    
        if username.isEmpty || password.isEmpty {
            observer.present(alertController, animated: true)
            return false
        }
        
        return true
    }
    
}
