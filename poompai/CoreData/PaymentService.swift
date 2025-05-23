//
//  PaymentService.swift
//  poompai
//
//  Created by 김경호 on 4/28/25.
//

import CoreData
import Foundation

final class PaymentService {
    static func addPayment(to group: Group, payer: Member, amount: Int64, participants: [Member], title:String, discountRate: Int64 = 0) -> Payment {
        let payment = Payment(context: CoreDataManager.shared.context)
        payment.id = UUID()
        payment.amount = amount
        payment.createdAt = Date()
        payment.group = group
        payment.payer = payer
        payment.participants = NSSet(array: participants)
        payment.discountRate = discountRate
        payment.title = title
        CoreDataManager.shared.saveContext()
        
        return payment
    }
    
    static func getPayment(for group: Group) -> [Payment] {
        let request: NSFetchRequest<Payment> = Payment.fetchRequest()
        request.predicate = NSPredicate(format: "group == %@", group)

        do {
            return try CoreDataManager.shared.context.fetch(request)
        } catch {
            debugPrint("Payment Fetch Error for group: \(error)")
            return []
        }
    }
    
    static func addSettlements(payment: Payment, _ settlement: Settlement) {
        payment.addToSettlements(settlement)
        CoreDataManager.shared.saveContext()
    }
    
    static func deletePayment(payment: Payment) {
        CoreDataManager.shared.context.delete(payment)
        CoreDataManager.shared.saveContext()
    }
}
