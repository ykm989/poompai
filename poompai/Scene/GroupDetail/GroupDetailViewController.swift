//
//  GroupDetailViewController.swift
//  poompai
//
//  Created by 김경호 on 4/29/25.
//

import UIKit

final class GroupDetailViewController: UIViewController {
    
    private let viewModel: GroupDetailViewModel
    
    init(viewModel: GroupDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
}
