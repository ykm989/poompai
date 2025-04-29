//
//  GroupDetailViewModel.swift
//  poompai
//
//  Created by 김경호 on 4/29/25.
//

import Foundation

final class GroupDetailViewModel {
    let group: Group
    let memberList: [Member]
    let paymentList: [Payment]
    
    init(group: Group) {
        self.group = group
        self.memberList = MemberService.getMembers()
        self.paymentList = PaymentService.getPayment()
    }
}
