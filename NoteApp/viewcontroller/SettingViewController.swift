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
    }
    
    private func setUpViews(){
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
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

}
