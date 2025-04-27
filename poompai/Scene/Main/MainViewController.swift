//
//  MainViewController.swift
//  poompai
//
//  Created by 김경호 on 4/6/25.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let groupListView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .lightGray
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GroupListCell.self, forCellWithReuseIdentifier: "GroupListCell")
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpLayout()
        
        
        // MARK: - test
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(groupAddButtonTouched))
    }
}

// MARK: - UI Settings

extension MainViewController {
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
        
        self.view.backgroundColor = .white
    }
    
    private func addViews() {
        [ groupListView ].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            groupListView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            groupListView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            groupListView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            groupListView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
}

// MARK: - Button Methods

private extension MainViewController {
    @objc func groupAddButtonTouched() {
        let groupViewController = GroupViewController(viewModel: GroupViewModel())
        
        self.navigationController?.pushViewController(groupViewController, animated: true)
    }
}
