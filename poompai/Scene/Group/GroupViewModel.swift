//
//  GroupViewModel.swift
//  poompai
//
//  Created by 김경호 on 4/8/25.
//

import Combine
import Foundation

final class GroupViewModel: ObservableObject {
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    
    private var groupName: String = ""
    var userList: [String] = []
    
    enum Input {
        case userAdd(String)
        case groupNameInput(String)
        case complete
    }
    
    enum Output {
        case userAdd
        case isCompletePossible
        case isCompleteImpossible
        case createComplete(Group)
    }
}

extension GroupViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {
                case let .userAdd(userName):
                    self?.userList.append(userName)
                    self?.outputSubject.send(.userAdd)
                    self?.canCompleteGroup()
                case let .groupNameInput(groupName):
                    self?.groupName = groupName
                    self?.canCompleteGroup()
                case .complete:
                    self?.createGroup()
                }
            }
            .store(in: &subscriptions)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func canCompleteGroup() {
        if groupName != "" && !userList.isEmpty {
            self.outputSubject.send(.isCompletePossible)
        }
        else {
            self.outputSubject.send(.isCompleteImpossible)
        }
    }
    
    private func createGroup() {
        if groupName != "" && !self.userList.isEmpty {
            let createdGroup = GroupService.createGroup(name: groupName)
            self.userList.forEach {
                let member = MemberService.addMember(to: createdGroup, name: $0)
                GroupService.addMember(group: createdGroup, member)
            }
            
            self.outputSubject.send(.createComplete(createdGroup))
        }
    }
}
