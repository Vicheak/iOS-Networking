//
//  ForgetPasswordScreenViewController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 13/7/24.
//

import UIKit
import SnapKit
import KeychainSwift
import NVActivityIndicatorView

class ForgetPasswordScreenViewController: UIViewController {
    
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
        titleLabel.text = "Enter your email to reset password"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 20)
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
        emailTextField.placeholder = "Enter your email"
        return emailTextField
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
    var forgetPasswordButton = {
        let forgetPasswordButton = UIButton()
        forgetPasswordButton.setTitle("Send OTP Code", for: .normal)
        forgetPasswordButton.backgroundColor = .systemBlue
        forgetPasswordButton.layer.cornerRadius = 10
        return forgetPasswordButton
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
        
        emailTextField.delegate = self
        
        tapGestureRecognizer.addTarget(self, action: #selector(tapGestureRecognizerTapped))
        forgetPasswordButton.addTarget(self, action: #selector(forgetPasswordButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
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
        stackViewTextField.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(stackViewButton)
        stackViewButton.addArrangedSubview(forgetPasswordButton)
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
    
        forgetPasswordButton.snp.makeConstraints { make in
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
    
    @objc func forgetPasswordButtonTapped(){
        let email = emailTextField.text ?? ""
        
        validateForgetPassword(email: email)
    }
    
    @objc func loginButtonTapped(){
        dismiss(animated: true)
//        let resetPasswordScreenViewController = ResetPasswordViewController()
//        resetPasswordScreenViewController.email = "test@gmail.com"
//        resetPasswordScreenViewController.passwordToken = "asdfghjkl"
//        resetPasswordScreenViewController.modalTransitionStyle = .coverVertical
//        resetPasswordScreenViewController.modalPresentationStyle = .fullScreen
//        present(resetPasswordScreenViewController, animated: true)
    }
    
    private func validateForgetPassword(email: String){
        if  DataValidation.validateRequired(self, field: email, fieldName: "Email") {
            
            APIService.shared.forgetPassword(indicatorView: indicatorView, withEmail: email) { [weak self] complete, message, passwordToken in
                guard let forgetPassword = self else { return }
                var alertController: UIAlertController
                var alertAction: UIAlertAction
                
                if complete {
                    alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                    alertAction = UIAlertAction(title: "Verify OTP Code", style: .default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        
                        let verifyCodeScreenViewController = VerifyCodeScreenViewController()
                        verifyCodeScreenViewController.email = email
                        verifyCodeScreenViewController.passwordToken = passwordToken
                        verifyCodeScreenViewController.forgetPasswordScreen = forgetPassword
                        verifyCodeScreenViewController.modalTransitionStyle = .coverVertical
                        verifyCodeScreenViewController.modalPresentationStyle = .fullScreen
                        present(verifyCodeScreenViewController, animated: true)
                    })
                    alertController.addAction(alertAction)
                    forgetPassword.present(alertController, animated: true) {
                        [weak self] in
                        guard let self = self else { return }
                        emailTextField.text = ""
                    }
                } else {
                    alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    alertAction = UIAlertAction(title: "OK", style: .destructive)
                    alertController.addAction(alertAction)
                    forgetPassword.present(alertController, animated: true)
                }
            }
        }
    }
    
}

extension ForgetPasswordScreenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
