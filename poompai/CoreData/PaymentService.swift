//
//  PaymentService.swift
//  poompai
//
//  Created by 김경호 on 4/28/25.
//

import CoreData
import Foundation

final class PaymentService {
    static func addPayment(to group: Group, payer: Member, amount: Int64, participants: [Member]) {
        let payment = Payment(context: CoreDataManager.shared.context)
        payment.id = UUID()
        payment.amount = amount
        payment.createdAt = Date()
        payment.group = group
        payment.payer = payer
        payment.participants = NSSet(array: participants)
        CoreDataManager.shared.saveContext()
    }
    
    static func deletePayment(payment: Payment) {
        CoreDataManager.shared.context.delete(payment)
        CoreDataManager.shared.saveContext()
    }
}
