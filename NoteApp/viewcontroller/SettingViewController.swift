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
    
    lazy var userImageView = {
        let userImageView = UIImageView()
        userImageView.contentMode = .scaleAspectFit
        userImageView.tintColor = .black
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.clipsToBounds = true
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
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 30)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        return titleLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Setting"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.forward.circle"), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        
        setUpViews()
        
        let keychain = KeychainSwift()
        let username = keychain.get("username")
        titleLabel.text = "Welcome \(username!)"
        
        pickButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
    }
    
    private func setUpViews(){
        view.addSubview(userImageView)
        view.addSubview(pickButton)
        view.addSubview(titleLabel)
        
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.height.equalTo(150)
        }
        
        pickButton.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(30)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(pickButton.snp.bottom).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
    
    @objc func rightBarButtonTapped(sender: UIBarButtonItem){
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure to logout?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            UserDefaults.standard.set(false, forKey: "isLogin")
        
            let keychain = KeychainSwift()
            keychain.delete("username")
            
            CoreDataManager.shared.deleteAllData(entityName: "Folder")
            CoreDataManager.shared.deleteAllData(entityName: "Note")
            
            dismiss(animated: false)
        }
        let noAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        present(alertController, animated: true)
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
        print(info)
        if let image = info[.originalImage] as? UIImage {
            //save the seleted image as JPEG file
            let fileName = UUID().uuidString + ".jpg"
            if let savedURL = ImageUtil.saveImageAsJPEG(image, to: .documentDirectory, withName: fileName, compressionQuality: 0.8){
                print("Save image URL : \(savedURL)")
                
                //load image from document directory set to user image view
                //...
                userImageView.image = image
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
