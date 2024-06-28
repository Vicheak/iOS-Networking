//
//  HomeNavigationController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 26/6/24.
//

import UIKit

class HomeNavigationController: UINavigationController {
    
    let homeViewController = HomeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers([homeViewController], animated: true)
        
        navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

}
