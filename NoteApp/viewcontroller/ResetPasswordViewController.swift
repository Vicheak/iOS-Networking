//
//  ResetPasswordViewController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 13/7/24.
//

import UIKit
import SnapKit
import KeychainSwift
import NVActivityIndicatorView

class ResetPasswordViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var bottomConstraint: Constraint!
    var mainView = UIView()
    lazy var closeButton = {
        let closeButton = UIButton(type: .close)
        return closeButton
    }()
    lazy var stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.contentMode = .scaleToFill
        return stackView
    }()
    lazy var titleLabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Reset your password"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 30)
        return titleLabel
    }()
    lazy var stackViewTextField = {
        let stackViewTextField = UIStackView()
        stackViewTextField.axis = .vertical
        stackViewTextField.distribution = .fill
        stackViewTextField.alignment = .fill
        stackViewTextField.spacing = 20
        stackViewTextField.contentMode = .scaleToFill
        return stackViewTextField
    }()
    lazy var emailTextField = {
        let emailTextField = UITextField()
        emailTextField.borderStyle = .roundedRect
        emailTextField.isEnabled = false
        emailTextField.text = email.lowercased()
        return emailTextField
    }()
    var innerView1 = UIView()
    var innerView2 = UIView()
    lazy var passwordTextField = {
        let passwordTextField = UITextField()
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Enter password"
        passwordTextField.isSecureTextEntry = true
        return passwordTextField
    }()
    lazy var passwordConfirmTextField = {
        let passwordConfirmTextField = UITextField()
        passwordConfirmTextField.borderStyle = .roundedRect
        passwordConfirmTextField.placeholder = "Enter password confirmation"
        passwordConfirmTextField.isSecureTextEntry = true
        return passwordConfirmTextField
    }()
    lazy var eyeShowButton1 = {
        let eyeShowButton = UIButton()
        eyeShowButton.tintColor = .black
        eyeShowButton.setImage(eyeShowIcon, for: .normal)
        return eyeShowButton
    }()
    lazy var eyeShowButton2 = {
        let eyeShowButton = UIButton()
        eyeShowButton.tintColor = .black
        eyeShowButton.setImage(eyeShowIcon, for: .normal)
        return eyeShowButton
    }()
    lazy var stackViewButton = {
        let stackViewButton = UIStackView()
        stackViewButton.axis = .vertical
        stackViewButton.distribution = .equalCentering
        stackViewButton.alignment = .center
        stackViewButton.spacing = 40
        stackViewButton.contentMode = .scaleToFill
        return stackViewButton
    }()
    var resetPasswordButton = {
        let resetPasswordButton = UIButton()
        resetPasswordButton.setTitle("Reset", for: .normal)
        resetPasswordButton.backgroundColor = .systemBlue
        resetPasswordButton.layer.cornerRadius = 10
        return resetPasswordButton
    }()
    let tapGestureRecognizer = UITapGestureRecognizer()
    var keyboardUtil: KeyboardUtil!
    
    let eyeShowIcon = UIImage(named: "eye-show-icon")!
    let eyeHideIcon = UIImage(named: "eye-hide-icon")!
    
    let backgroundImage = UIImageView(image: UIImage(named: "register-form-img"))

    lazy var indicatorView = {
        let centerX = view.bounds.width / 2.0
        let centerY = view.bounds.height / 2.0
        let indicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: centerX - 50, y: centerY), size: CGSize(width: 100, height: 50)), type: .ballPulse, color: .systemBlue)
        view.addSubview(indicatorView)
        return indicatorView
    }()
    
    var email: String!
    var passwordToken: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .customBackgroundColor
        
        setUpView()
        
        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
        
        tapGestureRecognizer.addTarget(self, action: #selector(tapGestureRecognizerTapped))
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        eyeShowButton1.addTarget(self, action: #selector(togglePasswordShow), for: .touchUpInside)
        eyeShowButton2.addTarget(self, action: #selector(togglePasswordShow), for: .touchUpInside)
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
    }
    
    private func setUpView(){
        backgroundImage.frame = view.bounds
        backgroundImage.contentMode = .bottomLeft
        view.addSubview(backgroundImage)
    
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(mainView)
        mainView.addSubview(closeButton)
        mainView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(stackViewTextField)
        stackViewTextField.addArrangedSubview(emailTextField)
        stackViewTextField.addArrangedSubview(innerView1)
        innerView1.addSubview(passwordTextField)
        innerView1.addSubview(eyeShowButton1)
        stackViewTextField.addArrangedSubview(innerView2)
        innerView2.addSubview(passwordConfirmTextField)
        innerView2.addSubview(eyeShowButton2)
        stackView.addArrangedSubview(stackViewButton)
        stackViewButton.addArrangedSubview(resetPasswordButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            bottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).constraint
        }
        
        mainView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide).priority(.low)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.width.height.equalTo(30)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview().offset(10)
            make.bottom.lessThanOrEqualToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        eyeShowButton1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9)
            make.bottom.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(20)
            make.height.equalTo(15)
        }
        
        innerView2.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        passwordConfirmTextField.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        eyeShowButton2.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9)
            make.bottom.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(20)
            make.height.equalTo(15)
        }
        
        resetPasswordButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
    }
    
    @objc func tapGestureRecognizerTapped(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func togglePasswordShow(){
        eyeShowButton1.setImage(passwordTextField.isSecureTextEntry ? eyeHideIcon : eyeShowIcon, for: .normal)
        eyeShowButton2.setImage(passwordConfirmTextField.isSecureTextEntry ? eyeHideIcon : eyeShowIcon, for: .normal)
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        passwordConfirmTextField.isSecureTextEntry = !passwordConfirmTextField.isSecureTextEntry
    }
    
    @objc func resetPasswordButtonTapped(){
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let passwordConfirmation = passwordConfirmTextField.text ?? ""
        
        validateResetPassword(email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
    
    @objc func closeButtonTapped(){
        alertClose(withMessage: "")
    }
    
    func alertClose(withMessage message: String){
        dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name.resetPassword, object: message)
        })
    }
    
    private func validateResetPassword(email: String, password: String, passwordConfirmation: String){
        if DataValidation.validateRequired(self, field: password, fieldName: "Password") && DataValidation.validateRequired(self, field: passwordConfirmation, fieldName: "Password Confirmation"){
            if password.count < 8 {
                let alertController = UIAlertController(title: "Error", message: "The password must be at least 8 characters!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .destructive)
                alertController.addAction(alertAction)
                present(alertController, animated: true)
                return
            }
            if password != passwordConfirmation {
                let alertController = UIAlertController(title: "Error", message: "The password confirmation does not match", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .destructive)
                alertController.addAction(alertAction)
                present(alertController, animated: true)
                return
            }
            
            APIService.shared.resetPassword(indicatorView: indicatorView, withPassword: password, withPasswordToken: passwordToken) { [weak self] complete, message, _ in
                guard let self = self else { return }
                var alertController: UIAlertController
                var alertAction: UIAlertAction
                
                if complete {
                    alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                    alertAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        
                        alertClose(withMessage: message)
                    })
                    alertController.addAction(alertAction)
                    present(alertController, animated: true) {
                        [weak self] in
                        guard let self = self else { return }
                        passwordTextField.text = ""
                        passwordConfirmTextField.text = ""
                        if !passwordTextField.isSecureTextEntry || !passwordConfirmTextField.isSecureTextEntry {
                            togglePasswordShow()
                        }
                    }
                } else {
                    alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    alertAction = UIAlertAction(title: "OK", style: .destructive)
                    alertController.addAction(alertAction)
                    present(alertController, animated: true)
                }
            }
        }
    }
    
}

extension ResetPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            passwordConfirmTextField.becomeFirstResponder()
        } else if textField == passwordConfirmTextField {
            passwordConfirmTextField.resignFirstResponder()
            view.endEditing(true)
        }
        
        return true
    }
    
}
