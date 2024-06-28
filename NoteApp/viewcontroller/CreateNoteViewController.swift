//
//  CreateNoteViewController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 27/6/24.
//

import UIKit

class CreateNoteViewController: TemplateViewController {
    
    var folder: Folder!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create New Note"
        titleTextField.placeholder = "Enter note title"
        detailTextView.text = "Enter note detaill"
    }
    
    @objc override func saveButtonTapped(sender: UIButton){
        let title = titleTextField.text ?? ""
        let detail = detailTextView.text ?? ""
                
        if DataValidation.validate(self, title: title, detail: detail){

            let note = Note(context: CoreDataManager.shared.context)
            note.noteID = UUID().uuidString
            note.title = title
            note.detail = detail
            
            do {
                folder.addToNotes(note)
                try CoreDataManager.shared.save()
                
                navigationController?.popViewController(animated: true)
            } catch {
                print("error : \(error)")
            }
        }
    }
    
}


