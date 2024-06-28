//
//  KeyboardUtil.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 27/6/24.
//

import UIKit
import SnapKit

class KeyboardUtil {
        
    var view: UIView
    var bottomConstraint: Constraint
    
    init(view: UIView, bottomConstraint: Constraint) {
        self.view = view
        self.bottomConstraint = bottomConstraint
        
        keyboardNotification()
    }
    
    func keyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification){
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        bottomConstraint.update(offset: keyboardFrame.height * (-1))
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: Notification){
        bottomConstraint.update(offset: 0)
        view.layoutIfNeeded()
    }
    
}
