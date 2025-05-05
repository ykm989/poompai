//
//  GroupDetailViewController.swift
//  poompai
//
//  Created by 김경호 on 4/29/25.
//

import Combine
import UIKit

final class GroupDetailViewController: UIViewController {
    
    private let viewModel: GroupDetailViewModel
    private let inputSubject: PassthroughSubject<GroupDetailViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    var onGroupDelete: ((Group) -> Void)?
    
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
        setupSummaryView()
        addTargets()
        setupNavigationBar()
        bind()
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
        self.summationButton.addTarget(self, action: #selector(summationButtonTouched), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = viewModel.group.name
        let barButton = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteGroupButtonTouched))
        barButton.tintColor = .systemRed
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    private func setupSummaryView() {
        let totalAmount = self.viewModel.paymentList.reduce(into: 0) { $0 += Int($1.amount) }
        summaryCardView.configure(totalAmount: totalAmount, memberCount: self.viewModel.memberList.count)
    }
    
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject.receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case let .addPaymentSuccess(payment):
                    self?.paymentListView.paymentItems.append(payment)
                    self?.setupSummaryView()
                case let .deleteGroupSuccess(group):
                    self?.onGroupDelete?(group)
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
    }
}

extension GroupDetailViewController {
    @objc func addPaymentButtonTouched() {
        let viewController = AddPaymentViewController(viewModel: self.viewModel)
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
    
    @objc func summationButtonTouched() {
        let viewModel = SummationViewModel(paymentList: self.viewModel.paymentList)
        let viewController = SummationViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func deleteGroupButtonTouched() {
        let alertAction = UIAlertController(title: "그룹을 삭제하겠습니까?", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        
        alertAction.addAction(UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.inputSubject.send(.deleteGroup)
        })
        alertAction.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alertAction, animated: true)
    }
}
