//
//  TabBarController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 26/6/24.
//

import UIKit
import KeychainSwift

class TabBarController: UITabBarController {
    
    let homeNavigationController = HomeNavigationController()
    let settingNavigationController = SettingNavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        homeNavigationController.tabBarItem = UITabBarItem(title: "Folder", image: UIImage(systemName: "folder"), tag: 0)
        homeNavigationController.tabBarItem.title = "Folder"
        settingNavigationController.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "gear"), tag: 0)
        settingNavigationController.tabBarItem.title = "Setting"
        settingNavigationController.tabBarItem.badgeColor = .red
        
//        let keychain = KeychainSwift()
//        let username = keychain.get("username")
        
//        settingNavigationController.tabBarItem.badgeValue = username
        
        setViewControllers([homeNavigationController, settingNavigationController], animated: true)
        selectedViewController = homeNavigationController
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
    }

}
