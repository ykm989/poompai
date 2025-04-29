//
//  MainViewController.swift
//  poompai
//
//  Created by 김경호 on 4/6/25.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let mainViewModel: MainViewModel
    
    private let groupListView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor(named: "BackgroundColor")
        collectionView.layer.cornerRadius = 15
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GroupListCell.self, forCellWithReuseIdentifier: "GroupListCell")
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpLayout()
    }
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Settings

extension MainViewController {
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
        setupNavigation()
        delegates()
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        self.navigationItem.title = "뿜빠이"
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
    
    private func setupNavigation() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(groupAddButtonTouched))
    }
    
    private func delegates() {
        self.groupListView.delegate = self
        self.groupListView.dataSource = self
    }
}

// MARK: - Button Methods

private extension MainViewController {
    @objc func groupAddButtonTouched() {
        let groupViewController = GroupViewController(viewModel: GroupViewModel())
        
        self.navigationController?.pushViewController(groupViewController, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mainViewModel.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupListCell", for: indexPath) as? GroupListCell else {
            return UICollectionViewCell()
        }
        let group = self.mainViewModel.groups[indexPath.row]
        cell.setName(group.name ?? "", indexPath.row)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 120
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = self.mainViewModel.groups[indexPath.row]
        let groupDetailViewController = GroupDetailViewController(viewModel: GroupDetailViewModel(group: group))
        self.navigationController?.pushViewController(groupDetailViewController, animated: true)
    }
}
