//
//  RegisterScreenViewController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 9/7/24.
//

import UIKit
import SnapKit
import KeychainSwift
import NVActivityIndicatorView

class RegisterScreenViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var bottomConstraint: Constraint!
    var mainView = UIView()
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
        titleLabel.text = "Register An Account"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 40.0)
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
    lazy var fullnameTextField = {
        let fullnameTextField = UITextField()
        fullnameTextField.borderStyle = .roundedRect
        fullnameTextField.placeholder = "Enter your full name"
        return fullnameTextField
    }()
    lazy var emailTextField = {
        let emailTextField = UITextField()
        emailTextField.borderStyle = .roundedRect
        emailTextField.placeholder = "Enter your email"
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
    var registerButton = {
        let registerButton = UIButton()
        registerButton.setTitle("Create An Account", for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.layer.cornerRadius = 10
        return registerButton
    }()
    var loginButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Back to Login", for: .normal)
        loginButton.setTitleColor(.systemPink, for: .normal)
        loginButton.titleLabel?.textAlignment = .center
        loginButton.backgroundColor = .white
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.systemPink.cgColor
        return loginButton
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .customBackgroundColor
        
        setUpView()
        
        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        fullnameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
        
        tapGestureRecognizer.addTarget(self, action: #selector(tapGestureRecognizerTapped))
        eyeShowButton1.addTarget(self, action: #selector(togglePasswordShow), for: .touchUpInside)
        eyeShowButton2.addTarget(self, action: #selector(togglePasswordShow), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
//        guard let previousTraitCollection = previousTraitCollection else { return }
        
        if traitCollection.horizontalSizeClass == .compact &&
            traitCollection.verticalSizeClass == .regular {
            //portrait
        } else if traitCollection.horizontalSizeClass == .regular &&
                traitCollection.verticalSizeClass == .compact {
            //landscape IPhone 15 Pro Max
        } else if traitCollection.horizontalSizeClass == .compact &&
                traitCollection.verticalSizeClass == .compact {
            //landscape IPhone 15 and IPhone SE Series
        } else {
            //IPad
        }
    }
    
    private func setUpView(){
        backgroundImage.frame = view.bounds
        backgroundImage.contentMode = .bottomLeft
        view.addSubview(backgroundImage)
    
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(mainView)
        mainView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(stackViewTextField)
        stackViewTextField.addArrangedSubview(fullnameTextField)
        stackViewTextField.addArrangedSubview(emailTextField)
        stackViewTextField.addArrangedSubview(innerView1)
        innerView1.addSubview(passwordTextField)
        innerView1.addSubview(eyeShowButton1)
        stackViewTextField.addArrangedSubview(innerView2)
        innerView2.addSubview(passwordConfirmTextField)
        innerView2.addSubview(eyeShowButton2)
        stackView.addArrangedSubview(stackViewButton)
        stackViewButton.addArrangedSubview(registerButton)
        stackViewButton.addArrangedSubview(loginButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            bottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).constraint
        }
        
        mainView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide).priority(.low)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview().offset(10)
            make.bottom.lessThanOrEqualToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-10)
            make.centerX.centerY.equalToSuperview()
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
        
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
        
        loginButton.snp.makeConstraints { make in
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
    
    @objc func registerButtonTapped(){
        let fullname = fullnameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let passwordConfirmation = passwordConfirmTextField.text ?? ""
        
        validateRegister(fullname: fullname, email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
    
    @objc func loginButtonTapped(){
        dismiss(animated: true)
//        let verifyCodeScreenViewController = VerifyCodeScreenViewController()
//        verifyCodeScreenViewController.email = ""
//        verifyCodeScreenViewController.modalTransitionStyle = .coverVertical
//        verifyCodeScreenViewController.modalPresentationStyle = .fullScreen
//        present(verifyCodeScreenViewController, animated: true)
    }
    
    private func validateRegister(fullname: String, email: String, password: String, passwordConfirmation: String){        
        if DataValidation.validateRequired(self, field: fullname, fieldName: "Full Name") && DataValidation.validateRequired(self, field: email, fieldName: "Email") &&
            DataValidation.validateRequired(self, field: password, fieldName: "Password") && DataValidation.validateRequired(self, field: passwordConfirmation, fieldName: "Password Confirmation"){
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
            
            APIService.shared.register(indicatorView: indicatorView, withFullname: fullname, withEmail: email, withPassword: password) { [weak self] complete, message, _ in
                guard let registerSelf = self else { return }
                var alertController: UIAlertController
                var alertAction: UIAlertAction
                
                if complete {
                    alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                    alertAction = UIAlertAction(title: "Verify Now", style: .default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        
//                        NotificationCenter.default.post(name: NSNotification.Name.verifyCode, object: email)
                        
                        let verifyCodeScreenViewController = VerifyCodeScreenViewController()
                        verifyCodeScreenViewController.email = email
                        verifyCodeScreenViewController.registerScreen = registerSelf
                        verifyCodeScreenViewController.modalTransitionStyle = .coverVertical
                        verifyCodeScreenViewController.modalPresentationStyle = .fullScreen
                        present(verifyCodeScreenViewController, animated: true)
                    })
                    alertController.addAction(alertAction)
                    registerSelf.present(alertController, animated: true) {
                        [weak self] in
                        guard let self = self else { return }
                        fullnameTextField.text = ""
                        emailTextField.text = ""
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
                    registerSelf.present(alertController, animated: true)
                }
            }
        }
    }
    
}

extension RegisterScreenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullnameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordConfirmTextField.becomeFirstResponder()
        } else if textField == passwordConfirmTextField {
            passwordConfirmTextField.resignFirstResponder()
            view.endEditing(true)
        }
        
        return true
    }
    
}
