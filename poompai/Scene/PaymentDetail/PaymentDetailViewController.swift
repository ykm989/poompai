//
//  PaymentDetailViewController.swift
//  poompai
//
//  Created by 김경호 on 5/9/25.
//

import UIKit

final class PaymentDetailViewController: UIViewController {
//    private let payment: Payment
    private let viewModel: GroupDetailViewModel
    private let selectedPayment: Int
    private var selectedPayer: Member
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "제목"
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(named: "GroupCellColor")
        textField.layer.cornerRadius = 5
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        return textField
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "금액"
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        return label
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(named: "GroupCellColor")
        textField.layer.cornerRadius = 5
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        return textField
    }()
    
    private let payerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "결제자"
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        return label
    }()
    
    private let payerSelectButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("결제자 선택", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = UIColor(named: "GroupCellColor")
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let confirmEditButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("변경 저장", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("취소", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - init
    
    init(viewModel: GroupDetailViewModel, _ index: Int) {
        self.viewModel = viewModel
        self.selectedPayment = index
        self.selectedPayer = self.viewModel.paymentList[index].payer!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension PaymentDetailViewController {
    private func setupUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.titleTextField.text = self.viewModel.paymentList[selectedPayment].title
        self.amountTextField.text = self.viewModel.paymentList[selectedPayment].amount.description
        self.payerSelectButton.setTitle(self.viewModel.paymentList[selectedPayment].payer?.name ?? "Select payer", for: .normal)
        addViews()
        addConstraints()
        addTargets()
    }
    
    // MARK: - ADD View
    private func addViews() {
        self.view.addSubview(containerView)
        [ titleLabel, titleTextField, amountLabel, amountTextField, payerLabel, payerSelectButton, confirmEditButton, cancelButton ].forEach {
            self.containerView.addSubview($0)
        }
    }
    
    // MARK: - ADD Constraints
    private func addConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50),
            containerView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 100),
            
            titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            
            titleTextField.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 50),
            titleTextField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 30),
            titleTextField.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -30),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            amountLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 130),
            amountLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            
            amountTextField.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 120),
            amountTextField.leadingAnchor.constraint(equalTo: amountLabel.trailingAnchor, constant: 30),
            amountTextField.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -30),
            amountTextField.heightAnchor.constraint(equalToConstant: 50),
            
            payerLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 200),
            payerLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            
            payerSelectButton.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 190),
            payerSelectButton.leadingAnchor.constraint(equalTo: payerLabel.trailingAnchor, constant: 10),
            payerSelectButton.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -30),
            payerSelectButton.heightAnchor.constraint(equalToConstant: 50),
            
            confirmEditButton.topAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -150),
            confirmEditButton.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            confirmEditButton.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -20),
            confirmEditButton.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.topAnchor.constraint(equalTo: confirmEditButton.bottomAnchor, constant: 10),
            cancelButton.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // MARK: - Add Targets
    private func addTargets() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backGroundTouched))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        payerSelectButton.addTarget(self, action: #selector(selectPayer), for: .touchUpInside)
        confirmEditButton.addTarget(self, action: #selector(confirmEditTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
}

// MARK: - @objc
extension PaymentDetailViewController {
    @objc func backGroundTouched(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        
        // 컨테이너 바깥을 눌렀을 때만 dismiss
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
        
        self.view.endEditing(true)
    }
    
    @objc func selectPayer() {
        let alertController = UIAlertController(title: "결제자 선택", message: nil, preferredStyle: .actionSheet)
        
        for participant in self.viewModel.memberList {
            let action = UIAlertAction(title: participant.name, style: .default) { _ in
                self.selectedPayer = participant
                self.payerSelectButton.setTitle("\(self.selectedPayer.name ?? "")", for: .normal)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
    
    @objc func confirmEditTapped() {
        self.viewModel.paymentList[self.selectedPayment].title = self.titleTextField.text ?? ""
        self.viewModel.paymentList[self.selectedPayment].amount = Int64(Int(self.amountTextField.text ?? "0") ?? 0)
        self.viewModel.paymentList[self.selectedPayment].payer = selectedPayer
        
        dismiss(animated: true)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}
