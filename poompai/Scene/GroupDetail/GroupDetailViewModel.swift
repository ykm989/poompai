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
    var paymentList: [Payment]
    
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    
    enum Input {
        case addPayment(amount: Int, payer: Member, participants: Set<Member>, title: String)
        case deleteGroup
    }
    
    enum Output {
        case addPaymentSuccess(Payment)
        case deleteGroupSuccess(Group)
    }
    
    init(group: Group) {
        self.group = group
        self.memberList = MemberService.getMembers(for: group)
        self.paymentList = PaymentService.getPayment(for: group)
    }
}

extension GroupDetailViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case let .addPayment(amount, payer, participants, title):
                    if let group = self?.group {
                        let payment = PaymentService.addPayment(to: group, payer: payer, amount: Int64(amount), participants: Array(participants), title: title)
                        
                        let settlementAmount = Int(amount / Int(participants.count))
                        participants.forEach {
                            if payer != $0 {
                                let settlement = SettlementService.addSettlement(to: payment, payer: payer, amount: Int64(settlementAmount), receiver: $0)
                                PaymentService.addSettlements(payment: payment, settlement)
                            }
                        }
                        GroupService.addPayment(group: group, payment)
                        self?.paymentList.append(payment)
                        self?.outputSubject.send(.addPaymentSuccess(payment))
                    }
                case .deleteGroup:
                    self?.deleteGroup()
                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
    
    func deleteGroup() {
        GroupService.deleteGroup(group)
        outputSubject.send(.deleteGroupSuccess(group))
    }
}
