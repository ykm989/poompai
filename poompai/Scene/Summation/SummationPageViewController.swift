//
//  SummationPageViewController.swift
//  poompai
//
//  Created by 김경호 on 5/19/25.
//

import UIKit

final class SummationViewController: UIViewController {
    
    private let groupMembers:[Member]
    private let payments: [Payment]
    private var dataViewControllers: [UIViewController] = []
    
    lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.backgroundColor = .clear
        return pageViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupDelegate()
        configure()
    }
    
    init(members: [Member], payments: [Payment]) {
        self.groupMembers = members
        self.payments = payments
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension SummationViewController {
    func setupViewControllers() {
        let firstViewModel = SummationViewModel(paymentList: payments)
        let firstViewController = TotalSummationViewController(viewModel: firstViewModel)
        self.dataViewControllers = [firstViewController]
        
        let groupMembers = groupMembers.filter { member in
            payments.contains { payment in
                payment.payer == member || payment.participants?.contains(member) == true
            }
        }

        groupMembers.forEach {
            let memberPayment = payments.filter { payment in
                // payer가 그룹 멤버 중 한 명인지
                let isPayer = groupMembers.contains(where: { $0 == payment.payer })

                // participants에 그룹 멤버가 한 명이라도 있는지
                let isParticipant = groupMembers.contains { member in
                    (payment.participants?.contains(member) == true)
                }

                return isPayer || isParticipant
            }

            let vc = MemberSummationViewController(member: $0, payments: memberPayment)
            dataViewControllers.append(vc)
        }
    }
    
    func setupDelegate() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    func configure() {
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        self.navigationItem.title = "요약"
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        if let firstVc = dataViewControllers.first {
            pageViewController.setViewControllers([firstVc], direction: .forward, animated: true)
        }
        pageViewController.didMove(toParent: self)
    }
}

extension SummationViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return dataViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == dataViewControllers.count {
            return nil
        }
        return dataViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let currentVC = pageViewController.viewControllers?.first, let index = dataViewControllers.firstIndex(of: currentVC) else { return }
        
        if index == 0 {
            self.navigationItem.title = "요약"
        } else if let memberVC = currentVC as? MemberSummationViewController {
            self.navigationItem.title = memberVC.member.name
        }
    }
}
