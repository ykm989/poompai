//
//  SummationViewController.swift
//  poompai
//
//  Created by 김경호 on 5/1/25.
//

import UIKit

final class SummationViewController: UIViewController {
    
    private let viewModel: SummationViewModel
    
    private let expenditureView: ExpenditureView = {
        let view = ExpenditureView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "GroupCellColor")
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let transferLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "추천 이체"
        return label
    }()
    
    private let transferTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "transferCell")
        tableView.layer.cornerRadius = 10
        tableView.backgroundColor = UIColor(named: "GroupCellColor")
        return tableView
    }()
    
    init(viewModel: SummationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        setupUI()
    }
}

extension SummationViewController {
    func setupUI() {
        addTargets()
        setLayoutConstraints()
        expenditureView.setSummary(amount: viewModel.recommendedTransfers.reduce(into: 0) { $0 += $1.amount }, startDate: "2025.04.02", endDate: "2025.04.03")
        transferTableView.dataSource = self
        transferTableView.delegate = self
    }
    
    func addTargets() {
        [ expenditureView, transferLabel, transferTableView ].forEach {
            self.view.addSubview($0)
        }
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            expenditureView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            expenditureView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            expenditureView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            expenditureView.heightAnchor.constraint(equalToConstant: 140),
            
            transferLabel.topAnchor.constraint(equalTo: expenditureView.bottomAnchor, constant: 50),
            transferLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            
            transferTableView.topAnchor.constraint(equalTo: transferLabel.bottomAnchor, constant: 10),
            transferTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            transferTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            transferTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
}

extension SummationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recommendedTransfers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transferCell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: "GroupCellColor")
        let recommendedTransfer = viewModel.recommendedTransfers[indexPath.row]
        cell.textLabel?.text = "\(recommendedTransfer.to.name!) -> \(recommendedTransfer.from.name!) : \(recommendedTransfer.amount)"
        return cell
    }
}
