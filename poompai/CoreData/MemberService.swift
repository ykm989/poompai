//
//  MemberService.swift
//  poompai
//
//  Created by 김경호 on 4/28/25.
//

import CoreData
import Foundation

final class MemberService {
    static func addMember(to group: Group, name: String) {
        let member = Member(context: CoreDataManager.shared.context)
        member.id = UUID()
        member.name = name
        member.group = group
        CoreDataManager.shared.saveContext()
    }
    
    static func getMembers() -> [Member] {
        let request: NSFetchRequest<Member> = Member.fetchRequest()
        do {
            return try CoreDataManager.shared.context.fetch(request)
        } catch {
            debugPrint("Member Get Error \(error)")
            return []
        }
    }
    
    static func deleteMember(_ member: Member) {
        CoreDataManager.shared.context.delete(member)
        CoreDataManager.shared.saveContext()
    }
}
