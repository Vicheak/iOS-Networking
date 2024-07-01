//
//  LoginScreenViewController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 26/6/24.
//

import UIKit
import SnapKit
import KeychainSwift

class LoginScreenViewController: UIViewController {
    
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
    lazy var imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        guard let loginImageIcon = UIImage(named: "login-form-img") else {
            imageView.image = UIImage(systemName: "person.2.badge.key.fill")
            return imageView
        }
        imageView.image = loginImageIcon
        
        return imageView
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
    lazy var usernameTextField = {
        let usernameTextField = UITextField()
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.placeholder = "Enter username"
        return usernameTextField
    }()
    var innerView = UIView()
    lazy var passwordTextField = {
        let passwordTextField = UITextField()
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Enter password"
        passwordTextField.isSecureTextEntry = true
        return passwordTextField
    }()
    lazy var eyeShowButton = {
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
        stackViewButton.spacing = 0
        stackViewButton.contentMode = .scaleToFill
        return stackViewButton
    }()
    var loginButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 10
        return loginButton
    }()
    let tapGestureRecognizer = UITapGestureRecognizer()
    var keyboardUtil: KeyboardUtil!
    
    let eyeShowIcon = UIImage(named: "eye-show-icon")!
    let eyeHideIcon = UIImage(named: "eye-hide-icon")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validateScreen()
        
        view.backgroundColor = .customBackgroundColor
        
        setUpView()
        
        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        tapGestureRecognizer.addTarget(self, action: #selector(tapGestureRecognizerTapped))
        eyeShowButton.addTarget(self, action: #selector(togglePasswordShow), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animate: Bool){
        super.viewWillAppear(animate)
        validateScreen()
    }
    
    private func validateScreen(){
        let isLogin = UserDefaults.standard.bool(forKey: "isLogin")
        if isLogin {
            DispatchQueue.main.async { [weak self] in
                self?.view.isHidden = true
                self?.navigateToHome()
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.view.isHidden = false
            }
        }
    }
    
    private func setUpView(){
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(scrollView)
        scrollView.addSubview(mainView)
        mainView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(stackViewTextField)
        stackViewTextField.addArrangedSubview(usernameTextField)
        stackViewTextField.addArrangedSubview(innerView)
        innerView.addSubview(passwordTextField)
        innerView.addSubview(eyeShowButton)
        stackView.addArrangedSubview(stackViewButton)
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
            make.top.greaterThanOrEqualToSuperview().offset(0)
            make.leading.equalToSuperview().offset(10)
            make.bottom.lessThanOrEqualToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-10)
            make.centerX.centerY.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        innerView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        eyeShowButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9)
            make.bottom.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(20)
            make.height.equalTo(15)
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
//        if passwordTextField.isSecureTextEntry {
//            //hide password text
//            eyeShowButton.setImage(eyeHideIcon, for: .normal)
//            passwordTextField.isSecureTextEntry = false
//        } else {
//            //show password text
//            eyeShowButton.setImage(eyeShowIcon, for: .normal)
//            passwordTextField.isSecureTextEntry = true
//        }
        
        eyeShowButton.setImage(passwordTextField.isSecureTextEntry ? eyeHideIcon : eyeShowIcon, for: .normal)
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @objc func loginButtonTapped(){
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        validateLogin(username: username, password: password)
    }
    
    private func validateLogin(username: String, password: String){
        let isLogin = UserDefaults.standard.bool(forKey: "isLogin")
        if isLogin {
            navigateToHome()
        }
        
        if LoginValidation.validate(self, username: username, password: password){
            if (username.lowercased() == "admin" || username.lowercased() == "aditi") && password.lowercased() == "2024" {
                //store user setting
                UserDefaults.standard.set(true, forKey: "isLogin")
                let keychain = KeychainSwift()
                keychain.set(username.lowercased(), forKey: "username")
  
                navigateToHome()
            } else {
                let alertController = UIAlertController(title: "Error", message: "Incorrect username and password!" , preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .destructive)
                alertController.addAction(alertAction)
                present(alertController, animated: true)
            }
        }
    }
    
    private func navigateToHome(){
        //proceed home screen
        let tabBarController = TabBarController()
        
        present(tabBarController, animated: true) { [weak self] in
            guard let self = self else { return }
            usernameTextField.text = ""
            passwordTextField.text = ""
            if !passwordTextField.isSecureTextEntry {
                togglePasswordShow()
            }
        }
    }
    
}

extension LoginScreenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            view.endEditing(true)
        }
        return true
    }
    
}
