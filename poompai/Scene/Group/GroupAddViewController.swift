//
//  GroupAddViewController.swift
//  poompai
//
//  Created by 김경호 on 4/6/25.
//

import Combine
import UIKit

final class GroupAddViewController: UIViewController {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private let viewModel: GroupViewModel
    private let inputSubject: PassthroughSubject<GroupViewModel.Input, Never> = .init()
    
    // MARK: - UI Components
    
    private let addGroupView: UIView = {
        let view =  UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameInputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "  이름"
        textField.backgroundColor = .brown
        textField.autocapitalizationType = .none
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.backgroundColor = .brown
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(viewModel: GroupViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        bind()
    }
}

// MARK: - UI Settings

private extension GroupAddViewController {
    func setUpLayout() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        addViews()
        setLayoutConstraints()
        addTargets()
    }
    
    func addViews() {
        self.view.addSubview(addGroupView)
        
        [ nameInputTextField, saveButton, ].forEach {
            addGroupView.addSubview($0)
        }
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            self.addGroupView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.addGroupView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.addGroupView.widthAnchor.constraint(equalToConstant: 250),
            self.addGroupView.heightAnchor.constraint(equalToConstant: 100),
            
            self.nameInputTextField.topAnchor.constraint(equalTo: self.addGroupView.topAnchor),
            self.nameInputTextField.leadingAnchor.constraint(equalTo: self.addGroupView.leadingAnchor),
            self.nameInputTextField.trailingAnchor.constraint(equalTo: self.addGroupView.trailingAnchor),
            self.nameInputTextField.heightAnchor.constraint(equalToConstant: 50),
            
            self.saveButton.topAnchor.constraint(equalTo: self.nameInputTextField.bottomAnchor, constant: 10),
            self.saveButton.leadingAnchor.constraint(equalTo: self.addGroupView.leadingAnchor, constant: 20),
            self.saveButton.trailingAnchor.constraint(equalTo: self.addGroupView.trailingAnchor, constant: -20),
            self.saveButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func addTargets() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTouched))
        tapGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(tapGestureRecognizer)
        self.addGroupView.isUserInteractionEnabled = true
        
        self.saveButton.addTarget(self, action: #selector(saveButtonTouched), for: .touchUpInside)
    }
}

// MARK: - Button Methods

private extension GroupAddViewController {
    @objc func backgroundTouched() {
        self.dismiss(animated: false)
    }
    
    @objc func saveButtonTouched() {
        self.inputSubject.send(.userAdd(nameInputTextField.text ?? ""))
        self.dismiss(animated: false)
    }
}

// MARK: - Gesture

extension GroupAddViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.addGroupView.frame.contains(touch.location(in: view)) {
            return false
        }
        
        return true
    }
}

extension GroupAddViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
    }
}
