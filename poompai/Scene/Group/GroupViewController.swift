//
//  GroupViewController.swift
//  poompai
//
//  Created by 김경호 on 4/6/25.
//

import Combine
import UIKit

final class GroupViewController: UIViewController {
    
    // MARK: - Properties
    private var subscriptions: Set<AnyCancellable> = []
    private let viewModel: GroupViewModel
    private let inputSubject: PassthroughSubject<GroupViewModel.Input, Never> = .init()
    var onGroupCreated: ((Group) -> Void)?
    
    // MARK: - UI Components
    
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹명"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let groupNameTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.placeholder = "그룹명을 입력하세요."
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let userAddLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹원 추가"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.placeholder = "사용자명"
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let userAddButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
        button.setTitle("+ 추가", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let userListLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹원"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tablewView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 15
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let completeBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(completedButtonTouched))
    
    // MARK: - init

    init(viewModel: GroupViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        bind()
        delegates()
    }
}


// MARK: - UI Settings

private extension GroupViewController {
    func setUpLayout() {
        self.view.backgroundColor = .secondarySystemBackground
        self.navigationItem.title = "그룹 추가"
        
        addViews()
        setLayoutConstraints()
        addTargets()
        setupNavigation()
    }
    
    func addViews() {
        [ groupNameLabel, groupNameTextField, userAddLabel, userNameTextField, userAddButton, userListLabel, tablewView ].forEach {
            self.view.addSubview($0)
        }
    }
    
    func setupNavigation() {
        self.navigationItem.rightBarButtonItem = completeBarButton
        completeBarButton.isEnabled = false
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            groupNameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            groupNameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            groupNameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            groupNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            groupNameTextField.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 10),
            groupNameTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            groupNameTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            groupNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            userAddLabel.topAnchor.constraint(equalTo: groupNameTextField.bottomAnchor, constant: 20),
            userAddLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            userAddLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            userNameTextField.topAnchor.constraint(equalTo: userAddLabel.bottomAnchor, constant: 10),
            userNameTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            userNameTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            userAddButton.topAnchor.constraint(equalTo: self.userNameTextField.bottomAnchor, constant: 20),
            userAddButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            userAddButton.heightAnchor.constraint(equalToConstant: 50),
            userAddButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            userAddButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            userListLabel.topAnchor.constraint(equalTo: self.userAddButton.bottomAnchor, constant: 30),
            userListLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            userListLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            tablewView.topAnchor.constraint(equalTo: self.userListLabel.bottomAnchor, constant: 20),
            tablewView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tablewView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tablewView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    // MARK: - addTargets
    private func addTargets() {
        self.userAddButton.addTarget(self, action: #selector(addUserButtonTouched), for: .touchUpInside)
        self.groupNameTextField.addTarget(self, action: #selector(groupNameTextFieldDidChanged(_:)), for: .editingChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTouched))
        
        self.view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Button Methods

private extension GroupViewController {
    @objc func addUserButtonTouched() {
        self.inputSubject.send(.userAdd(self.userNameTextField.text ?? ""))
        self.userNameTextField.text = ""
    }
    
    @objc func completedButtonTouched() {
        self.inputSubject.send(.complete)
    }
    
    @objc func groupNameTextFieldDidChanged(_ sender: Any?) {
        guard let groupName = self.groupNameTextField.text else { return }
        inputSubject.send(.groupNameInput(groupName))
    }
    
    @objc func backgroundTouched(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

// MARK: - Bind
private extension GroupViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .userAdd:
                    self?.tablewView.reloadData()
                case .isCompletePossible:
                    self?.completeBarButton.isEnabled = true
                    self?.completeBarButton.tintColor = .systemBlue
                case .isCompleteImpossible:
                    self?.completeBarButton.isEnabled = false
                    self?.completeBarButton.tintColor = .systemGray
                case let .createComplete(group):
                    self?.onGroupCreated?(group)
                    self?.navigationController?.popViewController(animated: true)
                    
                }
            }
            .store(in: &subscriptions)
    }
    
    func delegates() {
        tablewView.delegate = self
        tablewView.dataSource = self
        tablewView.register(GroupUserTableViewCell.self, forCellReuseIdentifier: GroupUserTableViewCell.id)
    }
}

extension GroupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupUserTableViewCell.id, for: indexPath) as? GroupUserTableViewCell else {
            return GroupUserTableViewCell(frame: .zero)
        }
        
        cell.setName(viewModel.userList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
