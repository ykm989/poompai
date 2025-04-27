//
//  GroupListCell.swift
//  poompai
//
//  Created by 김경호 on 4/6/25.
//

import UIKit

final class GroupListCell: UICollectionViewCell {
    static let id = "GroupListCell"
    
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    
    func setView() {
        self.addSubview(groupNameLabel)
        
        NSLayoutConstraint.activate([
            groupNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            groupNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
        ])
        
        self.backgroundColor = .white
    }
    
    func setName(_ name: String) {
        self.groupNameLabel.text = name
    }
}
