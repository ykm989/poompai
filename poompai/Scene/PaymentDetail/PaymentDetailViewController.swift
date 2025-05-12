//
//  PaymentDetailViewController.swift
//  poompai
//
//  Created by 김경호 on 5/9/25.
//

import UIKit

final class PaymentDetailViewController: UIViewController {
    private let payment: Payment
    
    // MARK: - init
    
    init(payment: Payment) {
        self.payment = payment
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "결제 상세"
    }
}
