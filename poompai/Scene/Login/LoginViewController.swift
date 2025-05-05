//
//  LoginViewController.swift
//  poompai
//
//  Created by 김경호 on 4/27/25.
//

import UIKit

final class LoginViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "뿜빠이"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sideLabel: UILabel = {
        let label = UILabel()
        label.text = "빠르게 나누는 정산"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // TODO: - 추후에 kakao 로그인 버튼으로 바꾸기
    private let logginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .yellow
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension LoginViewController {
    private func setupUI() {
        uiAdd()
        positionUI()
        self.view.backgroundColor = .white
    }
    
    private func uiAdd() {
        [titleLabel, sideLabel, logginButton].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func positionUI() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sideLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            sideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logginButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            logginButton.heightAnchor.constraint(equalToConstant: 50),
            logginButton.widthAnchor.constraint(equalToConstant: 200),
            logginButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -150)
        ])
    }
}
