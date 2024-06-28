//
//  EditFolderViewController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 27/6/24.
//

import UIKit

class EditFolderViewController: TemplateViewController {
    
    var folder: Folder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Folder"
    
        titleTextField.text = folder.name
        detailTextView.text = folder.detail
    }
    
    @objc override func saveButtonTapped(sender: UIButton){
        let title = titleTextField.text ?? ""
        let detail = detailTextView.text ?? ""
        
        if DataValidation.validate(self, title: title, detail: detail){
            if folder.name != title && !DataValidation.validateDuplication(self, name: title) {
                titleTextField.text = ""
                detailTextView.text = ""
                titleTextField.becomeFirstResponder()
                return
            }
            
            folder.name = title
            folder.detail = detail
            
            do {
                try CoreDataManager.shared.save()
                
                let alertController = UIAlertController(title: "Success", message: "A folder has been edited!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                    guard let self = self else { return }
                                
                    NotificationCenter.default.post(name: NSNotification.Name.editFolder, object: nil)
                    navigationController?.popViewController(animated: true)
                }
                alertController.addAction(alertAction)
                present(alertController, animated: true)
            } catch {
                print("error : \(error)")
            }
        }
    }
    
}
