//
//  ExpenditureView.swift
//  poompai
//
//  Created by 김경호 on 5/2/25.
//

import UIKit

final class ExpenditureView: UIView {
    private let expenditureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.text = "지출"
        return label
    }()
    
    private let amount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.text = ""
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExpenditureView {
    func setupUI() {
        [ expenditureLabel, amount, dateLabel ].forEach {
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            amount.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            amount.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            expenditureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            expenditureLabel.bottomAnchor.constraint(equalTo: amount.topAnchor, constant: -8),
            
            dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: amount.bottomAnchor, constant: 10),
        ])
    }
    
    func setSummary(amount: Int, startDate: String, endDate: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        self.amount.text = "₩ " + (numberFormatter.string(for: amount) ?? "0")
        self.dateLabel.text = "\(startDate) ~ \(endDate)"
    }
}
