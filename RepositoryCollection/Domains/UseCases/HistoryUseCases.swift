//
//  HistoryUseCases.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 09/06/2024.
//

import Foundation
import Combine

protocol HistoryUseCases {
    func fetchAllUseIDs() -> AnyPublisher<[Owner], Error>
}

class HistoryUseCasesIml: HistoryUseCases {
    
    func fetchAllUseIDs() -> AnyPublisher<[Owner], Error> {
        let subject = PassthroughSubject<[Owner], Error>()
        subject.send([])
        subject.send(completion: .finished)
        
        return subject.eraseToAnyPublisher()
    }
}
