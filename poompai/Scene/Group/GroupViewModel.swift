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
    
    var userList: [String] = []
    
    enum Input {
        case userAdd(String)
    }
    
    enum Output {
        case userAdd
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
                }
            }
            .store(in: &subscriptions)
        
        return outputSubject.eraseToAnyPublisher()
    }
}
