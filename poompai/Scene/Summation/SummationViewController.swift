//
//  SummationViewController.swift
//  poompai
//
//  Created by 김경호 on 5/1/25.
//

import UIKit

final class SummationViewController: UIViewController {
    
    private let viewModel: SummationViewModel
    
    init(viewModel: SummationViewModel) {
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
