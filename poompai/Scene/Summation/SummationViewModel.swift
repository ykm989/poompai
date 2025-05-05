//
//  SummationViewModel.swift
//  poompai
//
//  Created by 김경호 on 5/2/25.
//

import Foundation

final class SummationViewModel {
    private let paymentList: [Payment]
    private var settlementList: [Settlement] = []
    private var balanceMap = [Member: Int]()
    var recommendedTransfers: [Transfer] = []
    
    init(paymentList: [Payment]) {
        self.paymentList = paymentList
        
        paymentList.forEach {
            let settlement = SettlementService.getPayment(for: $0)
            settlementList.append(contentsOf: settlement)
        }
        
        // Step.1 Settlement 목록을 순회하며 net balance 계산
        settlementList.forEach {
            guard let payer = $0.payer else {
                return
            }
            balanceMap[payer, default: 0] -= Int($0.amount)
            
            guard let payee = $0.receiver else {
                return
            }
            balanceMap[payee, default: 0] += Int($0.amount)
        }
        
        // Step.2: 잔액이 음수인 사람과 양수인 사람을 나눔
        var debtors: [(Member, Int)] = []
        var creditors: [(Member, Int)] = []
        
        for (id, balance) in balanceMap {
            if balance == 0 { continue }
            
            if balance < 0 {
                debtors.append((id, -balance))
            } else {
                creditors.append((id, balance))
            }
        }
        
        // Step.3 Greedy 정산 - 최대한 서로 매칭해서 송금
        var dIndex = 0
        var cIndex = 0

        while dIndex < debtors.count && cIndex < creditors.count {
            var (debtor, debt) = debtors[dIndex]
            var (creditor, credit) = creditors[cIndex]
            
            let amount = min(debt, credit) // 가능한 송금 금액
            
            // 정산 쌍 추가
            recommendedTransfers.append(Transfer(from: debtor, to: creditor, amount: amount))
            
            // 잔액 갱신
            debtors[dIndex].1 -= amount
            creditors[cIndex].1 -= amount
            
            // 다 갚았으면 다음 사람으로 이동
            if debtors[dIndex].1 == 0 { dIndex += 1 }
            if creditors[cIndex].1 == 0 { cIndex += 1 }
        }
    }
}

extension SummationViewModel {
    struct Transfer {
        let from: Member
        let to: Member
        let amount: Int
    }

}
