//
//  PaymentRowView.swift
//  poompai
//
//  Created by 김경호 on 4/29/25.
//

import UIKit

final class PaymentRowView: UIView {

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        imageView.image = UIImage(systemName: "cup.and.saucer.fill")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()

    init(payment: Payment) {
        super.init(frame: .zero)
        setupView(payment: payment)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(payment: Payment) {
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        addViews()
        setLayoutConstraints()
        titleLabel.text = payment.title
        amountLabel.text = "\(payment.amount)원"
    }
    
    private func addViews() {
        [ iconImageView, titleLabel, amountLabel ].forEach {
            self.addSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -10),

            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
