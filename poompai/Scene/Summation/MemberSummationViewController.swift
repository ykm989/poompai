//
//  MemberSummationViewController.swift
//  poompai
//
//  Created by 김경호 on 5/19/25.
//

import UIKit

final class MemberSummationViewController: UIViewController {
    
    let member: Member
    let payments: [Payment]
    
    // MARK: - UI Components
    
    private let summationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "GroupCellColor")
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let transferLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "입출금액"
        label.textColor = .systemGray
        return label
    }()
    
    private let transferAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        return label
    }()
    
    private let depositLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "입금"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let depositAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let withdrawalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "출금"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let withdrawalAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let paymentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        return label
    }()
    
    private let paymentAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recommendedTransferLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "추천 이체"
        return label
    }()
    
    private let paymentTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MemberPaymentTableViewCell.self, forCellReuseIdentifier: "MemberPaymentTableViewCell")
        tableView.layer.cornerRadius = 10
        tableView.backgroundColor = UIColor(named: "GroupCellColor")
        return tableView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        setupView()
        super.viewDidLoad()
    }
    
    // MARK: - Init
    
    init(member: Member, payments: [Payment]) {
        self.member = member
        self.payments = payments
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MemberSummationViewController {
    private func setupView() {
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        addViews()
        setLayoutConstraints()
        setupSummationText()
        setupDelegates()
    }
    
    private func addViews() {
        self.view.addSubview(summationView)
        [ transferLabel, transferAmountLabel, depositLabel, depositAmountLabel, withdrawalLabel, withdrawalAmountLabel, paymentLabel, paymentAmountLabel, recommendedTransferLabel ].forEach {
            self.summationView.addSubview($0)
        }
        self.view.addSubview(paymentTableView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            summationView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            summationView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            summationView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            summationView.heightAnchor.constraint(equalToConstant: 140),
            
            transferLabel.topAnchor.constraint(equalTo: summationView.topAnchor, constant: 10),
            transferLabel.centerXAnchor.constraint(equalTo: summationView.centerXAnchor),
            
            transferAmountLabel.topAnchor.constraint(equalTo: transferLabel.bottomAnchor, constant: 5),
            transferAmountLabel.centerXAnchor.constraint(equalTo: summationView.centerXAnchor),
            
            depositLabel.topAnchor.constraint(equalTo: transferAmountLabel.bottomAnchor, constant: 10),
            depositLabel.leadingAnchor.constraint(equalTo: summationView.leadingAnchor, constant: 20),
            
            depositAmountLabel.topAnchor.constraint(equalTo: transferAmountLabel.bottomAnchor, constant: 10),
            depositAmountLabel.trailingAnchor.constraint(equalTo: summationView.trailingAnchor, constant: -20),
            
            withdrawalLabel.topAnchor.constraint(equalTo: depositLabel.bottomAnchor, constant: 5),
            withdrawalLabel.leadingAnchor.constraint(equalTo: summationView.leadingAnchor, constant: 20),
            
            withdrawalAmountLabel.topAnchor.constraint(equalTo: depositAmountLabel.bottomAnchor, constant: 5),
            withdrawalAmountLabel.trailingAnchor.constraint(equalTo: summationView.trailingAnchor, constant: -20),
            
            recommendedTransferLabel.topAnchor.constraint(equalTo: withdrawalAmountLabel.bottomAnchor, constant: 60),
            recommendedTransferLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            recommendedTransferLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            paymentTableView.topAnchor.constraint(equalTo: recommendedTransferLabel.bottomAnchor, constant: 10),
            paymentTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            paymentTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            paymentTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    private func setupSummationText() {
        self.navigationItem.title = member.name
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let totalAmount = payments.reduce(into: 0) { $0 += Int($1.amount) }
        let depositAmount = self.payments
            .filter { $0.payer == self.member }
            .reduce(into: 0) { $0 += Int($1.amount) }
        let withdrawalAmount = self.payments
            .filter { $0.payer != self.member }
            .reduce(into: 0) { $0 += Int($1.amount) }
        
        self.transferAmountLabel.text = (numberFormatter.string(for: totalAmount) ?? "0") + " 원"
        self.depositAmountLabel.text = numberFormatter.string(for: depositAmount)
        self.withdrawalAmountLabel.text = numberFormatter.string(for: withdrawalAmount)
    }
    
    private func setupDelegates() {
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
    }
}

extension MemberSummationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberPaymentTableViewCell", for: indexPath) as? MemberPaymentTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: "GroupCellColor")
        let recommendedTransfer = payments[indexPath.row]
        cell.textLabel?.text = "\(recommendedTransfer.payer?.name ?? "") <- \(recommendedTransfer.amount)"

        return cell
    }
}
