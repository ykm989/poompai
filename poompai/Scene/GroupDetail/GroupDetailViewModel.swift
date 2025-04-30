//
//  GroupDetailViewModel.swift
//  poompai
//
//  Created by 김경호 on 4/29/25.
//

import Combine
import Foundation

final class GroupDetailViewModel {
    let group: Group
    let memberList: [Member]
    let paymentList: [Payment]
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    
    enum Input {

    }
    
    enum Output {
        case addPaymentSuccess
    }
    
    init(group: Group) {
        self.group = group
        self.memberList = MemberService.getMembers()
        self.paymentList = PaymentService.getPayment()
    }
}

extension GroupDetailViewModel {
    func transfrom(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
}
