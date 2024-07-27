//
//  SettingViewController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 26/6/24.
//

import UIKit
import SnapKit
import KeychainSwift

class SettingViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var mainView = UIView()
    lazy var stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.contentMode = .scaleToFill
        return stackView
    }()
    lazy var userImageView = {
        let userImageView = UIImageView()
        userImageView.contentMode = .scaleAspectFit
        userImageView.tintColor = .black
        userImageView.image = UIImage(systemName: "person.circle.fill")
        return userImageView
    }()
    lazy var pickButton = {
        let pickButton = UIButton()
        pickButton.setTitle("Choose Image", for: .normal)
        pickButton.backgroundColor = .blue
        pickButton.layer.cornerRadius = 10
        return pickButton
    }()
    lazy var titleLabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    lazy var viewUserButton = {
        let viewUserButton = UIButton()
        viewUserButton.setTitle("View User Info", for: .normal)
        viewUserButton.backgroundColor = .systemBlue
        viewUserButton.layer.cornerRadius = 10
        viewUserButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return viewUserButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Setting"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "arrowshape.forward.circle"), style: .plain, target: self, action: #selector(rightBarButtonTapped)),
            UIBarButtonItem(image: UIImage(systemName: "person.crop.square.fill"), style: .plain, target: self, action: #selector(toViewUserInfoViewController))
        ]
        
        setUpViews()
        
        let keychain = KeychainSwift()
        let username = keychain.get("username")
        titleLabel.text = "Welcome \(username!)"
        
        //load image from document directory
        let imageName = UserDefaults.standard.string(forKey: "imageName")
        if let imageName = imageName {
            let fileManager = FileManager.default
            let directoryPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filePath = directoryPath.appendingPathComponent(imageName)
            
            if let image = UIImage(contentsOfFile: filePath.path) {
                UIView.transition(with: userImageView, duration: 1.5, options: [.transitionFlipFromLeft]) { [weak self] in
                    guard let self = self else { return }
                    userImageView.image = image
                } completion: { _ in }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    checkImageCircleBound(image: image)
                }
            } else {
                //handle image loading failure (e.g., file not found, invalid format)
                print("Error : could not load image from document directory : \(filePath)")
                 
                UIView.transition(with: userImageView, duration: 1.5, options: [.transitionFlipFromLeft]) { [weak self] in
                    guard let self = self else { return }
                    userImageView.image = UIImage(systemName: "person.circle.fill")
                } completion: { _ in }
            }
        }else {
            print("No image is found in user defaults")
        
            //set the default ui image
            UIView.transition(with: userImageView, duration: 1.5, options: [.transitionFlipFromLeft]) { [weak self] in
                guard let self = self else { return }
                userImageView.image = UIImage(systemName: "person.circle.fill")
            } completion: { _ in }
        }
        
        pickButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        viewUserButton.addTarget(self, action: #selector(toViewUserInfoViewController), for: .touchUpInside)
    }
    
    private func setUpViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(mainView)
        mainView.addSubview(stackView)
        mainView.addSubview(viewUserButton)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(userImageView)
        stackView.addArrangedSubview(pickButton)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(scrollView.contentLayoutGuide)
            make.width.height.equalTo(scrollView.frameLayoutGuide)
        }
        
        viewUserButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.height.equalTo(25)
            make.width.equalTo(120)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().offset(0)
            make.leading.equalToSuperview().offset(10)
            make.bottom.lessThanOrEqualToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-10)
            make.centerX.centerY.equalToSuperview()
        }
        
        userImageView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.width.equalTo(150)
        }
        
        pickButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
    }
    
    @objc func rightBarButtonTapped(sender: UIBarButtonItem){
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure to logout?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            //remove all images from document directory
            FileUtil.deleteAllFileInDirectory(path: .documentDirectory)
            
            UserDefaults.standard.set(false, forKey: "isLogin")
            UserDefaults.standard.set("", forKey: "imageName")
        
            let keychain = KeychainSwift()
            keychain.delete("username")
            
            CoreDataManager.shared.deleteAllData(entityName: "Folder")
            CoreDataManager.shared.deleteAllData(entityName: "Note")
            
            tabBarController?.modalTransitionStyle = .crossDissolve
            
            dismiss(animated: true)
        }
        let noAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        present(alertController, animated: true)
    }
    
    @objc func toViewUserInfoViewController(sender: UIBarButtonItem){
        let userInfoViewController = UserInfoViewController()
        present(userInfoViewController, animated: true)
    }
    
    @objc func pickImage(sender: UIButton){
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            //handle the case where the source type is not available
            return
        }
        ImageUtil.checkPhotoPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    self.presentImagePickerController(sourceType: .photoLibrary)
                } else {
                    self.presentCameraSettings()
                }
            }
        }
    }
    
    func presentImagePickerController(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }

    func presentCameraSettings(){
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        let alertController = UIAlertController(title: "Error", message: "Access is denied", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel, handler: { _ in
            UIApplication.shared.open(url, options: [:])
        }))
        present(alertController, animated: true, completion: nil)
    }
    
}

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            //save the seleted image as JPEG file
            let fileName = UUID().uuidString + ".jpg"
            if let savedURL = ImageUtil.saveImageAsJPEG(image, to: .documentDirectory, withName: fileName, compressionQuality: 0.8){
                print("Save image URL : \(savedURL)")
                
                //set to user image view
                UIView.transition(with: userImageView, duration: 1.5, options: [.transitionFlipFromLeft]) { [weak self] in
                    guard let self = self else { return }
                    userImageView.image = image
                } completion: { _ in }
              
                checkImageCircleBound(image: image)
                
                //store image name in user defaults
                //and if user uploads new image, overwrite the filename to new image name
                UserDefaults.standard.set(fileName, forKey: "imageName")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func checkImageCircleBound(image: UIImage){
        if ImageUtil.checkEqualImageScale(image: image) {
            userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
            userImageView.layer.masksToBounds = true
        }else{
            userImageView.layer.cornerRadius = 0
            userImageView.layer.masksToBounds = false
        }
    }
    
}
