//
//  GroupDetailViewController.swift
//  poompai
//
//  Created by 김경호 on 4/29/25.
//

import UIKit

final class GroupDetailViewController: UIViewController {
    
    private let viewModel: GroupDetailViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let summaryCardView: SummaryCardView = {
        let summaryCardView = SummaryCardView()
        summaryCardView.translatesAutoresizingMaskIntoConstraints = false
        return summaryCardView
    }()
    
    private let summationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("요약", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = UIColor(named: "GroupCellColor")
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let paymentListView: PaymentListView = {
        let view = PaymentListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        return view
    }()

    
    init(viewModel: GroupDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        paymentListView.paymentItems = viewModel.paymentList
    }
}

// MARK: - UI Settings
private extension GroupDetailViewController {
    private func setupUI() {
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        addViews()
        setLayoutConstraints()
        summaryCardView.configure(totalAmount: 20000, memberCount: 5)
        addTargets()
        setupNavigationBar()
    }
    
    private func addViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
    
        [ summaryCardView, paymentListView, summationButton ].forEach {
            scrollContentView.addSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollContentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollContentView.heightAnchor.constraint(equalToConstant: 1000),
            
            summaryCardView.topAnchor.constraint(equalTo: self.scrollContentView.topAnchor, constant: 10),
            summaryCardView.leadingAnchor.constraint(equalTo: self.scrollContentView.leadingAnchor, constant: 10),
            summaryCardView.trailingAnchor.constraint(equalTo: self.scrollContentView.trailingAnchor, constant: -10),
            
            summationButton.topAnchor.constraint(equalTo: self.summaryCardView.bottomAnchor, constant: 10),
            summationButton.leadingAnchor.constraint(equalTo: self.scrollContentView.leadingAnchor, constant: 10),
            summationButton.trailingAnchor.constraint(equalTo: self.scrollContentView.trailingAnchor, constant: -10),
            
            paymentListView.topAnchor.constraint(equalTo: self.summationButton.bottomAnchor, constant: 10),
            paymentListView.leadingAnchor.constraint(equalTo: self.scrollContentView.leadingAnchor, constant: 10),
            paymentListView.trailingAnchor.constraint(equalTo: self.scrollContentView.trailingAnchor, constant: -10),
        ])
    }
    
    private func addTargets() {
        self.paymentListView.setAddPaymentButtonAction(#selector(addPaymentButtonTouched), target: self)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = viewModel.group.name
    }
}

extension GroupDetailViewController {
    @objc func addPaymentButtonTouched() {
        let viewController = AddPaymentViewController(participants: viewModel.memberList)
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
}
