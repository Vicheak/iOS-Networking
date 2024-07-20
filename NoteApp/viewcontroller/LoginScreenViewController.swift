//
//  LoginScreenViewController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 26/6/24.
//

import UIKit
import SnapKit
import KeychainSwift
import NVActivityIndicatorView

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
//    lazy var imageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        
//        guard let loginImageIcon = UIImage(named: "login-form-img") else {
//            imageView.image = UIImage(systemName: "person.2.badge.key.fill")
//            return imageView
//        }
//        imageView.image = loginImageIcon
//        
//        return imageView
//    }()
    lazy var titleLabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Login"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 45.0)
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
    lazy var usernameTextField = {
        let usernameTextField = UITextField()
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.placeholder = "Enter email"
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
        stackViewButton.spacing = 100
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
    lazy var stackViewDownButton = {
        let stackViewButton = UIStackView()
        stackViewButton.axis = .vertical
        stackViewButton.distribution = .fill
        stackViewButton.alignment = .fill
        stackViewButton.spacing = 20
        stackViewButton.contentMode = .scaleToFill
        return stackViewButton
    }()
    var registerButton = {
        let registerButton = UIButton()
        registerButton.titleLabel?.textAlignment = .center
        registerButton.setTitle("Register an account", for: .normal)
        registerButton.setTitleColor(.systemBlue, for: .normal)
        registerButton.backgroundColor = .white
        registerButton.layer.cornerRadius = 10
        registerButton.layer.borderWidth = 3
        registerButton.layer.borderColor = UIColor.systemBlue.cgColor
        return registerButton
    }()
    var forgetPasswordButton = {
        let forgetPasswordButton = UIButton()
        forgetPasswordButton.titleLabel?.textAlignment = .center
        forgetPasswordButton.setTitle("Forget passsword?", for: .normal)
        forgetPasswordButton.setTitleColor(.systemPink, for: .normal)
        forgetPasswordButton.backgroundColor = .white
        forgetPasswordButton.layer.cornerRadius = 10
        forgetPasswordButton.layer.borderWidth = 3
        forgetPasswordButton.layer.borderColor = UIColor.systemPink.cgColor
        return forgetPasswordButton
    }()
    let tapGestureRecognizer = UITapGestureRecognizer()
    var keyboardUtil: KeyboardUtil!
    
    let eyeShowIcon = UIImage(named: "eye-show-icon")!
    let eyeHideIcon = UIImage(named: "eye-hide-icon")!
    
    let backgroundImage = UIImageView(image: UIImage(named: "login-form-img"))
    
    lazy var indicatorView = {
        let centerX = view.bounds.width / 2.0
        let centerY = view.bounds.height / 2.0
        let indicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: centerX - 50, y: centerY), size: CGSize(width: 100, height: 50)), type: .ballPulse, color: .systemBlue)
        view.addSubview(indicatorView)
        return indicatorView
    }()
    
    
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
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        forgetPasswordButton.addTarget(self, action: #selector(forgetPasswordButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animate: Bool){
        super.viewWillAppear(animate)
        validateScreen()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
//        guard let previousTraitCollection = previousTraitCollection else { return }
        
        backgroundImage.frame = view.bounds
        if traitCollection.horizontalSizeClass == .compact &&
            traitCollection.verticalSizeClass == .regular {
            //portrait
            backgroundImage.contentMode = .bottom
        } else if traitCollection.horizontalSizeClass == .regular &&
                traitCollection.verticalSizeClass == .compact {
            //landscape IPhone 15 Pro Max
            backgroundImage.contentMode = .center
        } else if traitCollection.horizontalSizeClass == .compact &&
                traitCollection.verticalSizeClass == .compact {
            //landscape IPhone 15 and IPhone SE Series
            backgroundImage.contentMode = .center
        } else {
            //IPad
            backgroundImage.contentMode = .bottom
        }
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
        backgroundImage.frame = view.bounds
        backgroundImage.contentMode = .bottom
        view.addSubview(backgroundImage)
    
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(mainView)
        mainView.addSubview(stackView)
//        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(stackViewTextField)
        stackViewTextField.addArrangedSubview(usernameTextField)
        stackViewTextField.addArrangedSubview(innerView)
        innerView.addSubview(passwordTextField)
        innerView.addSubview(eyeShowButton)
        stackView.addArrangedSubview(stackViewButton)
        stackViewButton.addArrangedSubview(loginButton)
        stackViewButton.addArrangedSubview(stackViewDownButton)
        stackViewDownButton.addArrangedSubview(registerButton)
        stackViewDownButton.addArrangedSubview(forgetPasswordButton)
        
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
            make.bottom.equalToSuperview().offset(-50)
            make.trailing.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
        }
        
//        imageView.snp.makeConstraints { make in
//            make.height.equalTo(100)
//        }
        
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
        
        stackViewDownButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
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
    
    @objc func registerButtonTapped(){
        let registerScreenViewController = RegisterScreenViewController()
        registerScreenViewController.modalPresentationStyle = .popover
        present(registerScreenViewController, animated: true)
    }
    
    @objc func forgetPasswordButtonTapped(){
        let forgetPasswordScreenViewController = ForgetPasswordScreenViewController()
        forgetPasswordScreenViewController.modalPresentationStyle = .popover
        present(forgetPasswordScreenViewController, animated: true)
    }
    
    private func validateLogin(username: String, password: String){
        let isLogin = UserDefaults.standard.bool(forKey: "isLogin")
        if isLogin {
            navigateToHome()
        }
        
        if LoginValidation.validate(self, username: username, password: password){
            APIService.shared.login(indicatorView: indicatorView, withUsername: username, withPassword: password) { [weak self] complete, message, accessToken in
                guard let self = self else { return }
                if complete {
                    //store user setting
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    let keychain = KeychainSwift()
                    keychain.set(username.lowercased(), forKey: "username")
                    //store access token
                    if let accessToken = accessToken {
                        keychain.set(accessToken, forKey: "accessToken")
                        navigateToHome()
                    } else {
                        //in case there is an error extracting access token from the server
                        let alertController = UIAlertController(title: "Error", message: "Failed to extract access token!", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .destructive)
                        alertController.addAction(alertAction)
                        present(alertController, animated: true)
                    }
                } else {
                    if message.contains("not verified") {
                        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Later", style: .destructive)
                        let verifyAlertAction = UIAlertAction(title: "Verify Now", style: .default) { [weak self] _ in
                            guard let self = self else { return }
                            let verifyCodeScreenViewController = VerifyCodeScreenViewController()
                            verifyCodeScreenViewController.email = username
                            verifyCodeScreenViewController.modalTransitionStyle = .coverVertical
                            verifyCodeScreenViewController.modalPresentationStyle = .fullScreen
                            present(verifyCodeScreenViewController, animated: true)
                        }
                        alertController.addAction(alertAction)
                        alertController.addAction(verifyAlertAction)
                        present(alertController, animated: true)
                        return
                    }
                    
                    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .destructive)
                    alertController.addAction(alertAction)
                    present(alertController, animated: true)
                }
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
