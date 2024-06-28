//
//  TemplateViewController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 27/6/24.
//

import UIKit
import SnapKit

class TemplateViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var mainView = UIView()
    lazy var titleTextField = {
        let titleTextField = UITextField()
        titleTextField.font = UIFont(name: "HelveticaNeue", size: 17)
        titleTextField.placeholder = "Enter title"
        titleTextField.borderStyle = .roundedRect
        return titleTextField
    }()
    lazy var detailTextView = {
        let detailTextView = UITextView()
        detailTextView.font = UIFont(name: "HelveticaNeue", size: 17)
        detailTextView.text = "Enter detail"
        detailTextView.textColor = .lightGray
        detailTextView.layer.borderWidth = 0.4
        detailTextView.layer.borderColor = UIColor.lightGray.cgColor
        detailTextView.layer.cornerRadius = 5
        return detailTextView
    }()
    lazy var saveButton = {
        let saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 10
        return saveButton
    }()
    var bottomConstraint: Constraint!
    let tapGuestureRecognizer = UITapGestureRecognizer()
    var keyboardUtil: KeyboardUtil!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpView()
        
        titleTextField.delegate = self
        detailTextView.delegate = self
        
        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        tapGuestureRecognizer.addTarget(self, action: #selector(viewEndEdit))
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func viewEndEdit(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func saveButtonTapped(sender: UIButton){
   
    }
 
    private func setUpView(){
        view.addSubview(scrollView)
        scrollView.addSubview(mainView)
        mainView.addGestureRecognizer(tapGuestureRecognizer)
        mainView.addSubview(titleTextField)
        mainView.addSubview(detailTextView)
        mainView.addSubview(saveButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            bottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).constraint
        }
        
        mainView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide).priority(.low)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.greaterThanOrEqualTo(150)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(detailTextView.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(150)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let previousTraitCollection = previousTraitCollection else { return }
        
        if previousTraitCollection.verticalSizeClass == .regular &&
            previousTraitCollection.horizontalSizeClass == .compact {
            //portrait
        } else if previousTraitCollection.verticalSizeClass == .compact &&
                    previousTraitCollection.horizontalSizeClass == .regular {
            //landscape iPhone 15 pro max
        } else if previousTraitCollection.verticalSizeClass == .compact &&
                    previousTraitCollection.horizontalSizeClass == .compact {
            //landscape iPhone 15 and iPhone SE series
        } else {
            //iPad trait
        }
    }
    
}

extension TemplateViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            detailTextView.becomeFirstResponder()
        }
        return true
    }
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == detailTextView.text {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
}
