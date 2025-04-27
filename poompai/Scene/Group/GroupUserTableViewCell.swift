//
//  GroupUserTableViewCell.swift
//  poompai
//
//  Created by 김경호 on 4/16/25.
//

import UIKit

final class GroupUserTableViewCell: UITableViewCell {
    static let id = "GroupUserTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setView()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder")
    }
    
    func setView() {
        self.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setName(_ name: String) {
        self.nameLabel.text = name
    }
}
