//
//  CreateFolderViewController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 27/6/24.
//

import UIKit

class CreateFolderViewController: TemplateViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create New Folder"
        titleTextField.placeholder = "Enter folder name"
        detailTextView.text = "Enter folder detaill"
    }
    
    @objc override func saveButtonTapped(sender: UIButton){
        let title = titleTextField.text ?? ""
        let detail = detailTextView.text ?? ""
    
        if DataValidation.validate(self, title: title, detail: detail){
            if !DataValidation.validateDuplication(self, name: title) {
                titleTextField.text = ""
                detailTextView.text = ""
                titleTextField.becomeFirstResponder()
                return
            }
            
            let folder = Folder(context: CoreDataManager.shared.context)
            folder.folderID = UUID().uuidString
            folder.name = title
            folder.detail = detail
            
            do {
                try CoreDataManager.shared.save()
                
                NotificationCenter.default.post(name: NSNotification.Name.saveFolder, object: nil)
                navigationController?.popViewController(animated: true)
            }  catch {
                print("error : \(error)")
            }
        }
    }
    
}


