//
//  EditNoteViewController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 27/6/24.
//

import UIKit

class EditNoteViewController: TemplateViewController {

    var note: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Note"
        
        titleTextField.text = note.title
        detailTextView.text = note.detail
    }
    
    @objc override func saveButtonTapped(sender: UIButton){
        let title = titleTextField.text ?? ""
        let detail = detailTextView.text ?? ""
        
        if DataValidation.validate(self, title: title, detail: detail){
            
            note.title = title
            note.detail = detail
            
            do {
                try CoreDataManager.shared.save()
                
                let alertController = UIAlertController(title: "Success", message: "A note has been edited!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    
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
