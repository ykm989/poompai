//
//  GroupListCell.swift
//  poompai
//
//  Created by 김경호 on 4/6/25.
//

import UIKit

final class GroupListCell: UICollectionViewCell {
    static let id = "GroupListCell"
    let colors = [UIColor.red, UIColor.blue, UIColor.yellow, UIColor.green]
    let images = ["cup.and.saucer.fill"]
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
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
        [ imageView, groupNameLabel].forEach{
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            
            groupNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            groupNameLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 20),
        ])
        
        self.backgroundColor = UIColor(named: "GroupCellColor")
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
    }
    
    func setName(_ name: String, _ index: Int) {
        self.groupNameLabel.text = name
        self.imageView.image = UIImage(systemName: images[index % images.count])
    }
}
