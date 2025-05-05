//
//  SummaryCardView.swift
//  poompai
//
//  Created by 김경호 on 4/29/25.
//

import UIKit

final class SummaryCardView: UIView {
    private let totalTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "총 결제금액"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let memberTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "참여 인원"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let memberCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = UIColor(named: "GroupCellColor")
        self.layer.cornerRadius = 16
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.05
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 6
        
        addViews()
        setLayoutConstraints()
    }
    
    private func addViews() {
        [ totalTitleLabel, totalAmountLabel, separator, memberTitleLabel, memberCountLabel ].forEach {
            self.addSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            totalTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            totalTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            totalAmountLabel.topAnchor.constraint(equalTo: totalTitleLabel.bottomAnchor, constant: 10),
            totalAmountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            separator.topAnchor.constraint(equalTo: self.totalAmountLabel.bottomAnchor, constant: 16),
            separator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            memberTitleLabel.topAnchor.constraint(equalTo: self.separator.bottomAnchor, constant: 16),
            memberTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            memberCountLabel.topAnchor.constraint(equalTo: self.memberTitleLabel.bottomAnchor, constant: 4),
            memberCountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            memberCountLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
        ])
    }
    
    func configure(totalAmount: Int, memberCount: Int) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        totalAmountLabel.text = (numberFormatter.string(for: totalAmount) ?? "0") + "원"
        memberCountLabel.text = "\(memberCount)명"
    }
}
