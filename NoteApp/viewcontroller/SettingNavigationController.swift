//
//  SettingNavigationController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 26/6/24.
//

import UIKit

class SettingNavigationController: UINavigationController {
    
    let settingViewController = SettingViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers([settingViewController], animated: true)
    
        navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

}
