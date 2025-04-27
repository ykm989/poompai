//
//  GroupViewModel.swift
//  poompai
//
//  Created by 김경호 on 4/8/25.
//

import Combine

final class GroupViewModel: ObservableObject {
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    
    private var groupName: String = ""
    var userList: [String] = []
    
    enum Input {
        case userAdd(String)
        case complete
        case groupNameInput(String)
    }
    
    enum Output {
        case userAdd
        case isCompletePossible
        case isCompleteImpossible
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
                    debugPrint("complete")
                }
            }
            .store(in: &subscriptions)
        
        return outputSubject.eraseToAnyPublisher()
    }
    
    private func canCompleteGroup() {
        debugPrint("test", groupName, groupName != "", !userList.isEmpty, groupName != "" && !userList.isEmpty)
        if groupName != "" && !userList.isEmpty {
            self.outputSubject.send(.isCompletePossible)
        }
        else {
            self.outputSubject.send(.isCompleteImpossible)
        }
    }
}
