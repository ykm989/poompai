//
//  MainViewModel.swift
//  poompai
//
//  Created by 김경호 on 4/28/25.
//

import Combine
import CoreData
import Foundation

final class MainViewModel:ObservableObject {
    private var subscriptions: Set<AnyCancellable> = []
    private let outputSubject = PassthroughSubject<Output, Never>()
    
    var groups: [Group]
    
    enum Input {
    }
    
    enum Output {
    }
    
    init() {
        self.groups = GroupService.fetchGroups()
    }
}

extension MainViewModel {
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                switch input {

                }
            }
            .store(in: &subscriptions)
        return outputSubject.eraseToAnyPublisher()
    }
}
