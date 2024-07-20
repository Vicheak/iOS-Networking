//
//  VerifyCodeScreenViewController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 10/7/24.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

class VerifyCodeScreenViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var bottomConstraint: Constraint!
    var mainView = UIView()
    lazy var closeButton = {
        let closeButton = UIButton(type: .close)
        return closeButton
    }()
    lazy var resendCodeButton = {
        let resendCodeButton = UIButton()
        resendCodeButton.setTitle("Resend OTP Code", for: .normal)
        resendCodeButton.backgroundColor = .systemBlue
        resendCodeButton.layer.cornerRadius = 10
        resendCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return resendCodeButton
    }()
    lazy var stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.contentMode = .scaleToFill
        return stackView
    }()
    lazy var titleLabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Enter OTP Code to Verify"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        return titleLabel
    }()
    var innerView = UIView()
    lazy var stackViewTextField = {
        let stackViewTextField = UIStackView()
        stackViewTextField.axis = .horizontal
        stackViewTextField.distribution = .equalCentering
        stackViewTextField.alignment = .center
        stackViewTextField.spacing = 10
        stackViewTextField.contentMode = .scaleToFill
        return stackViewTextField
    }()
    lazy var codeTextField1 = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
    }()
    lazy var codeTextField2 = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
    }()
    lazy var codeTextField3 = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
    }()
    lazy var codeTextField4 = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
    }()
    lazy var stackViewButton = {
        let stackViewButton = UIStackView()
        stackViewButton.axis = .vertical
        stackViewButton.distribution = .equalCentering
        stackViewButton.alignment = .center
        stackViewButton.spacing = 15
        stackViewButton.contentMode = .scaleToFill
        return stackViewButton
    }()
    lazy var verifyButton = {
        let verifyButton = UIButton()
        verifyButton.setTitle("Verify", for: .normal)
        verifyButton.backgroundColor = .systemBlue
        verifyButton.layer.cornerRadius = 10
        return verifyButton
    }()
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    var keyboardUtil: KeyboardUtil!
    
    lazy var indicatorView = {
        let centerX = view.bounds.width / 2.0
        let centerY = view.bounds.height / 2.0
        let indicatorView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: centerX - 50, y: centerY), size: CGSize(width: 100, height: 50)), type: .ballPulse, color: .systemBlue)
        view.addSubview(indicatorView)
        return indicatorView
    }()
    
    var email: String!
    var passwordToken: String?
    var registerScreen: RegisterScreenViewController?
    var forgetPasswordScreen: ForgetPasswordScreenViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .customBackgroundColor
        
        setUpView()
        
        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        codeTextField1.delegate = self
        codeTextField2.delegate = self
        codeTextField3.delegate = self
        codeTextField4.delegate = self
        
        //observe the notification
//        NotificationCenter.default.addObserver(self, selector: #selector(verifyWithEmail), name: NSNotification.Name.verifyCode, object: nil)
        
        tapGestureRecognizer.addTarget(self, action: #selector(tapGestureRecognizerTapped))
        resendCodeButton.addTarget(self, action: #selector(resendCodeButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        verifyButton.addTarget(self, action: #selector(verifyButtonTapped), for: .touchUpInside)
    }
    
    private func setUpView(){
        let backgroundImage = UIImageView(image: UIImage(named: "register-form-img"))
        backgroundImage.frame = view.bounds
        backgroundImage.contentMode = .bottomLeft
        view.addSubview(backgroundImage)
        
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(mainView)
        mainView.addSubview(resendCodeButton)
        mainView.addSubview(closeButton)
        mainView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(innerView)
        innerView.addSubview(stackViewTextField)
        stackViewTextField.addArrangedSubview(codeTextField1)
        stackViewTextField.addArrangedSubview(codeTextField2)
        stackViewTextField.addArrangedSubview(codeTextField3)
        stackViewTextField.addArrangedSubview(codeTextField4)
        stackView.addArrangedSubview(stackViewButton)
        stackViewButton.addArrangedSubview(verifyButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            bottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).constraint
        }
        
        mainView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide).priority(.low)
        }
        
        resendCodeButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.height.equalTo(25)
            make.width.equalTo(120)
        }
    
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.width.height.equalTo(30)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().offset(0)
            make.leading.equalToSuperview().offset(10)
            make.bottom.lessThanOrEqualToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-10)
            make.centerX.centerY.equalToSuperview()
        }
        
        innerView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        stackViewTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        codeTextField1.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        codeTextField2.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        codeTextField3.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        codeTextField4.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        verifyButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(150)
        }
    }
    
//    @objc func verifyWithEmail(notification: Notification){
//        guard let email = notification.object as? String else { return }
//        self.email = email
//    }
    
    @objc func tapGestureRecognizerTapped(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func resendCodeButtonTapped(){
        APIService.shared.resendCode(indicatorView: indicatorView, withEmail: email!) { [weak self] complete, message, _ in
            guard let self = self else { return }
            var alertController: UIAlertController
            var alertAction: UIAlertAction

            if complete {
                alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                alertAction = UIAlertAction(title: "OK", style: .destructive)
            } else {
                alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alertAction = UIAlertAction(title: "OK", style: .destructive)
            }
            
            alertController.addAction(alertAction)
            present(alertController, animated: true)
        }
    }
    
    @objc func closeAllScreen(){
        dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            
            if let registerScreen = registerScreen {
                registerScreen.dismiss(animated: false)
            }
            
            if let forgetPasswordScreen = forgetPasswordScreen {
                forgetPasswordScreen.dismiss(animated: false)
            }
        }
    }
    
    @objc func closeButtonTapped(){
        dismiss(animated: true)
    }
    
    @objc func verifyButtonTapped(){
        let code1 = codeTextField1.text ?? ""
        let code2 = codeTextField2.text ?? ""
        let code3 = codeTextField3.text ?? ""
        let code4 = codeTextField4.text ?? ""
        
        let message = "Please fill in OTP Code, it will be expired in 5 minutes"
        
        //validate OTP code
        if DataValidation.validateRequired(self, field: code1, fieldName: "", message: message) &&
            DataValidation.validateRequired(self, field: code2, fieldName: "", message: message) &&
            DataValidation.validateRequired(self, field: code3, fieldName: "", message: message) &&
            DataValidation.validateRequired(self, field: code4, fieldName: "", message: message) {
            let otpCode = code1 + code2 + code3 + code4
            print("OTP Code : \(otpCode)")
            
            APIService.shared.verifyCode(indicatorView: indicatorView, withEmail: email!, withOtpCode: otpCode) { [weak self] complete, message, _ in
                guard let self = self else { return }

                if complete {
                    if let passwordToken = passwordToken {
                        //present screen reset password
                        let resetPasswordScreenViewController = ResetPasswordViewController()
                        resetPasswordScreenViewController.email = email
                        resetPasswordScreenViewController.passwordToken = passwordToken
                        resetPasswordScreenViewController.modalTransitionStyle = .coverVertical
                        resetPasswordScreenViewController.modalPresentationStyle = .fullScreen
                        present(resetPasswordScreenViewController, animated: true) { [weak self] in
                            guard let self = self else { return }
                            NotificationCenter.default.addObserver(self, selector: #selector(closeAllScreen), name: NSNotification.Name.resetPassword, object: nil)
                        }
                        return
                    }
                    
                    closeAllScreen()
                } else {
                    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .destructive)
                    alertController.addAction(alertAction)
                    present(alertController, animated: true)
                }
            }
        }
    }

}

extension VerifyCodeScreenViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Check if the replacement string is a number
        if let _ = Int(string) {
            // Get the current text
            let currentText = textField.text ?? ""
            
            // Compute the new text
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Allow change if new text length is 1 or less
            if newText.count <= 1 {
                if newText.count == 1 {
                    // Move to the next text field if input is valid
                    if textField == codeTextField1 {
                        codeTextField1.text = newText
                        codeTextField2.becomeFirstResponder()
                    } else if textField == codeTextField2 {
                        codeTextField2.text = newText
                        codeTextField3.becomeFirstResponder()
                    } else if textField == codeTextField3 {
                        codeTextField3.text = newText
                        codeTextField4.becomeFirstResponder()
                    }
                }
                return true
            }
        } else if string.isEmpty {
            // Move to the previous text field to handle backspace
            if textField == codeTextField1 {
                codeTextField1.text = ""
            } else if textField == codeTextField2 {
                codeTextField2.text = ""
                codeTextField1.becomeFirstResponder()
            } else if textField == codeTextField3 {
                codeTextField3.text = ""
                codeTextField2.becomeFirstResponder()
            } else if textField == codeTextField4 {
                codeTextField4.text = ""
                codeTextField3.becomeFirstResponder()
            }
            return false
        }
        
        // Disallow any non-number input
        return string.isEmpty
    }
    
}
