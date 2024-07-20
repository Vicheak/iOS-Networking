//
//  DataValidation.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 27/6/24.
//

import UIKit

class DataValidation {
    
    static func validateRequired(_ observer: UIViewController, field: String, fieldName: String, message: String = "This field is required!") -> Bool {
        var alertController: UIAlertController
        let alertAction = UIAlertAction(title: "OK", style: .destructive)
        var alertMessage = message
        
        if field.isEmpty {
            if !fieldName.isEmpty {
                alertMessage = "\(fieldName) is required!"
            }
            alertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
            alertController.addAction(alertAction)
            
            observer.present(alertController, animated: true)
            return false
        }
        
        return true
    }
    
    static func validate(_ observer: UIViewController, title: String, detail: String, messages: [String] = [
        "Please enter title!",
        "Please enter detail!"
    ]) -> Bool {
        var alertController: UIAlertController
        let alertAction = UIAlertAction(title: "OK", style: .destructive)
        
        if title.isEmpty {
            alertController = UIAlertController(title: "Error", message: messages[0], preferredStyle: .alert)
            alertController.addAction(alertAction)
            
            observer.present(alertController, animated: true)
            return false
        }
        
        if detail.isEmpty {
            alertController = UIAlertController(title: "Error", message: messages[1], preferredStyle: .alert)
            alertController.addAction(alertAction)
            
            observer.present(alertController, animated: true)
            return false
        }
        
        return true
    }
    
    static func validateDuplication(_ observer: UIViewController, name: String, message: String = "Duplicate folder's name") -> Bool {
        do {
            try CoreDataManager.shared.checkForDuplicateName(name: name)
            return true
        } catch DataError.duplicateName {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in }
            alertController.addAction(okAction)
            
            observer.present(alertController, animated: true)
        } catch {
            print("error : \(error)")
        }
        return false
    }
    
}
