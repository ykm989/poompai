//
//  GroupService.swift
//  poompai
//
//  Created by 김경호 on 4/28/25.
//

import Foundation
import CoreData

final class GroupService {
    static func createGroup(name: String) {
        let group = Group(context: CoreDataManager.shared.context)
        group.id = UUID()
        group.name = name
        group.createdAt = Date()
        CoreDataManager.shared.saveContext()
    }
    
    static func fetchGroups() -> [Group] {
        let request: NSFetchRequest<Group> = Group.fetchRequest()
        do {
            return try CoreDataManager.shared.context.fetch(request)
        } catch {
            debugPrint("Group Fetch Error \(error)")
            return []
        }
    }
    
    static func updateGroupName(_ group: Group, newName: String) {
        group.name = newName
        CoreDataManager.shared.saveContext()
    }
    
    static func deleteGroup(_ group: Group) {
        CoreDataManager.shared.context.delete(group)
        CoreDataManager.shared.saveContext()
    }
}
