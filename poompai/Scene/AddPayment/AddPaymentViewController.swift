//
//  AddPaymentViewController.swift
//  poompai
//
//  Created by 김경호 on 4/29/25.
//

import Combine
import UIKit

final class AddPaymentViewController: UIViewController {
    private let viewModel: GroupDetailViewModel
    private let inputSubject: PassthroughSubject<GroupDetailViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private var selectedParticipants: Set<Member> = [] {
        didSet {
            checkCompleted()
        }
    }
    private var selectedPayer: Member? {
        didSet {
            checkCompleted()
        }
    }
    
    // MARK: - UI Componenets
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "결제 제목을 입력하세요."
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "결제 금액을 입력하세요."
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
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
    
    private let participantsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "정산 대상 선택"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let participantsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 8
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ParticipantCell")
        tableView.backgroundColor = UIColor(named: "BackgroundColor")
        return tableView
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemGray4
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - Init

    init(viewModel: GroupDetailViewModel, nibName: String? = nil, bundle: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: bundle)
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

// MARK: - UI Settings

extension AddPaymentViewController {
    private func setupUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addViews()
        addConstraints()
        setDelegates()
        addTargets()
        bind()
    }
    
    private func addViews() {
        self.view.addSubview(containerView)
        [ titleTextField, amountTextField, payerSelectButton, participantsLabel, participantsTableView, completeButton ].forEach {
            self.containerView.addSubview($0)
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 100),
            containerView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50),
            
            titleTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            amountTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            amountTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            amountTextField.heightAnchor.constraint(equalToConstant: 50),
            
            payerSelectButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            payerSelectButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            payerSelectButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            payerSelectButton.heightAnchor.constraint(equalToConstant: 50),
            
            participantsLabel.topAnchor.constraint(equalTo: payerSelectButton.bottomAnchor, constant: 10),
            participantsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            participantsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            participantsTableView.topAnchor.constraint(equalTo: participantsLabel.bottomAnchor, constant: 10),
            participantsTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            participantsTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            participantsTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -110),
            
            completeButton.topAnchor.constraint(equalTo: participantsTableView.bottomAnchor, constant: 20),
            completeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setDelegates() {
        self.participantsTableView.delegate = self
        self.participantsTableView.dataSource = self
    }
    
    private func addTargets() {
        titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        amountTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        payerSelectButton.addTarget(self, action: #selector(selectPayer), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonTouched), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backGroundTouched))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func checkCompleted() {
        let isTitleFilled = (titleTextField.text?.count ?? 0 > 0)
        let isAmountFilled = Int(amountTextField.text ?? "0") ?? 0 > 0
        
        let isSelectedPayer = !selectedParticipants.isEmpty
        let isSelectedParticipants = selectedPayer != nil
        
        let isFormValid = isTitleFilled && isAmountFilled && isSelectedPayer && isSelectedParticipants

        completeButton.isEnabled = isFormValid
        completeButton.backgroundColor = isFormValid ? UIColor(named: "GroupCellColor") : UIColor.systemGray4
        completeButton.setTitleColor(isFormValid ? .blue : .white, for: .normal)
    }
    
    private func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        outputSubject.receive(on: DispatchQueue.main).sink { [weak self] output in
            switch output {
            default: break
            }
        }
        .store(in: &cancellables)
    }
}

// MARK: - @objc

extension AddPaymentViewController {
    @objc func completeButtonTouched() {
        let amount = Int(amountTextField.text ?? "0") ?? 0
        let title = titleTextField.text ?? ""
        guard let selectedPayer = selectedPayer else {
            return
        }
        
        self.inputSubject.send(.addPayment(amount: amount, payer: selectedPayer, participants: selectedParticipants, title: title))
        self.dismiss(animated: true)
    }
    
    @objc func textFieldDidChange() {
        checkCompleted()
    }
    
    @objc func selectPayer() {
        let alertController = UIAlertController(title: "결제자 선택", message: nil, preferredStyle: .actionSheet)
        
        for participant in self.viewModel.memberList {
            let action = UIAlertAction(title: participant.name, style: .default) { _ in
                self.selectedPayer = participant
                self.payerSelectButton.setTitle("결제자: \(participant.name ?? "")", for: .normal)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
    
    @objc func backGroundTouched(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        let location = sender.location(in: self.view)
        
        // 컨테이너 바깥을 눌렀을 때만 dismiss
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - TableViewDelegate
extension AddPaymentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell", for: indexPath)
        cell.backgroundColor = UIColor(named: "GroupCellColor")
        let member = viewModel.memberList[indexPath.row]
        
        cell.textLabel?.text = member.name
        cell.accessoryType = selectedParticipants.contains(member) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = viewModel.memberList[indexPath.row]
        if selectedParticipants.contains(member) {
            selectedParticipants.remove(member)
        } else {
            selectedParticipants.insert(member)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
