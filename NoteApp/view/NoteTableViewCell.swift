//
//  NoteTableViewCell.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 27/6/24.
//

import UIKit
import SnapKit

class NoteTableViewCell: UITableViewCell {
    
    lazy var noteImageView = {
        let noteImageView = UIImageView()
        noteImageView.image = UIImage(systemName: "note.text")
        noteImageView.contentMode = .scaleAspectFill
        return noteImageView
    }()
    lazy var settingImageView = {
        let settingImageView = UIImageView()
        settingImageView.image = UIImage(systemName: "slider.horizontal.3")
        settingImageView.contentMode = .scaleAspectFill
        return settingImageView
    }()
    lazy var titleLabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    lazy var detailLabel = {
        let detailLabel = UILabel()
        detailLabel.textAlignment = .right
        return detailLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView(){
        contentView.addSubview(noteImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(settingImageView)
        contentView.addSubview(detailLabel)
        
        noteImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(noteImageView.snp.width)
        }

        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(noteImageView.snp.left).offset(30)
            make.bottom.equalToSuperview().offset(-20)
        }

        settingImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.trailing.equalToSuperview().offset(-5)
            make.height.equalTo(settingImageView.snp.width)
        }

        detailLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        detailLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(titleLabel.snp.right).offset(30)
            make.bottom.equalToSuperview().offset(-20)
            make.right.equalTo(settingImageView.snp.right).offset(-30)
        }
    }
    
}

