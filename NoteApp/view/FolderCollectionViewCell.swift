//
//  FolderCollectionViewCell.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 27/6/24.
//

import UIKit
import SnapKit

class FolderCollectionViewCell: UICollectionViewCell {

    lazy var folderImageView = {
        let folderImageView = UIImageView()
        folderImageView.contentMode = .scaleAspectFit
        folderImageView.tintColor = .folderColor
        
        guard let folderIcon = UIImage(named: "folder-icon") else {
            folderImageView.image = UIImage(systemName: "folder.fill")
            return folderImageView
        }
        folderImageView.image = folderIcon
        
        return folderImageView
    }()
    lazy var titleLabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    lazy var numberOfNoteLabel = {
        let numberOfNoteLabel = UILabel()
        numberOfNoteLabel.text = "notes()"
        numberOfNoteLabel.font = UIFont.boldSystemFont(ofSize: 15)
        numberOfNoteLabel.textColor = .black
        numberOfNoteLabel.textAlignment = .left
        return numberOfNoteLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setUpViews(){
        contentView.addSubview(folderImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(numberOfNoteLabel)
        
        folderImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.height.equalTo(folderImageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        numberOfNoteLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-5)
        }
    }
    
}

