//
//  SettlementService.swift
//  poompai
//
//  Created by 김경호 on 4/30/25.
//

import CoreData
import Foundation

final class SettlementService {
    static func addSettlement(to payment: Payment, payer: Member, amount: Int64, receiver: Member) -> Settlement {
        let settlement = Settlement(context: CoreDataManager.shared.context)
        settlement.id = UUID()
        settlement.payment = payment
        settlement.payer = payer
        settlement.receiver = receiver
        settlement.amount = amount
        CoreDataManager.shared.saveContext()
        
        return settlement
    }
    
    static func getSettlements(for payment: Payment) -> [Settlement] {
        let request: NSFetchRequest<Settlement> = Settlement.fetchRequest()
        request.predicate = NSPredicate(format: "payment == %@", payment)
        do {
            return try CoreDataManager.shared.context.fetch(request)
        } catch {
            debugPrint("SettlementService Get Error \(error)")
            return []
        }
    }
    
    static func deleteSettlement(settlement: Settlement) {
        CoreDataManager.shared.context.delete(settlement)
        CoreDataManager.shared.saveContext()
    }
}

