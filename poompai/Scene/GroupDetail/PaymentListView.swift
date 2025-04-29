//
//  PaymentListView.swift
//  poompai
//
//  Created by 김경호 on 4/29/25.
//

import UIKit

final class PaymentListView: UIView {

    // MARK: - Properties
    var paymentItems: [Payment] = [] {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - UI Components
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let addPaymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.setTitle("결제 추가", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.contentHorizontalAlignment = .leading
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = UIColor(named: "GroupCellColor")
        addViews()
        setLayoutConstraints()
    }
    
    private func addViews() {
        [ stackView, addPaymentButton ].forEach {
            self.addSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            addPaymentButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addPaymentButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            addPaymentButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            addPaymentButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            addPaymentButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func reloadData() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, item) in paymentItems.enumerated() {
            let paymentRow = PaymentRowView(payment: item)
            stackView.addArrangedSubview(paymentRow)

            // 마지막 항목이 아니면 separator 추가
            if index != paymentItems.count - 1 {
                let separator = UIView()
                separator.backgroundColor = UIColor.systemGray5
                separator.translatesAutoresizingMaskIntoConstraints = false
                separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
                stackView.addArrangedSubview(separator)
            }
        }
    }

    func setAddPaymentButtonAction(_ action: Selector, target: Any?) {
        addPaymentButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
