//
//  PaymentAddCell.swift
//  poompai
//
//  Created by 김경호 on 5/9/25.
//

import UIKit

final class PaymentTableViewCell: UITableViewCell {
    static let identifier = "PaymentAddCell"
    
    private let contentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let settlementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupViews() {
        addSubviews()
        setConstraints()
        self.backgroundColor = UIColor(named: "GroupCellColor")
    }
    
    func addSubviews() {
        self.addSubview(contentsView)
        [ titleLabel, settlementLabel, amountLabel ].forEach {
            self.contentsView.addSubview($0)
        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            contentsView.topAnchor.constraint(equalTo: self.topAnchor),
            contentsView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentsView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentsView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: self.contentsView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentsView.leadingAnchor, constant: 20),
            
            settlementLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            settlementLabel.leadingAnchor.constraint(equalTo: self.contentsView.leadingAnchor, constant: 20),
            
            amountLabel.topAnchor.constraint(equalTo: settlementLabel.bottomAnchor, constant: 3),
            amountLabel.trailingAnchor.constraint(equalTo: self.contentsView.trailingAnchor, constant: -10),
        ])
    }
    
    func setLabels(title: String, payment: Payment) {
        self.titleLabel.text = title
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        self.amountLabel.text = (numberFormatter.string(for: payment.amount) ?? "0") + "원"
        
        var members: [String] = []
        let receiverName = payment.payer?.name ?? ""
        
        if let settlements = payment.settlements as? Set<Settlement> {
            for settlement in settlements {
                members.append(settlement.payer?.name ?? "")
            }
        }

        settlementLabel.text = "\(receiverName) <- \(members.joined(separator: ", "))"
    }
}
