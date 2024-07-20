//
//  UserInfoViewController.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 20/7/24.
//

import UIKit
import SnapKit

class UserInfoViewController: UIViewController {
    
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
    let tapGestureRecognizer = UITapGestureRecognizer()
    var keyboardUtil: KeyboardUtil!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpViews()
    }
    
    func setUpViews(){
        
    }
    
}
