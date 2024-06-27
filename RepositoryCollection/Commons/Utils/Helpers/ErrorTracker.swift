//
//  ErrorTracker.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 23/11/2023.
//

import Foundation
import Combine

public typealias ErrorTracker = PassthroughSubject<ErrorMessage, Never>

extension Publisher where Failure: Error {
    public func trackError(_ errorTracker: ErrorTracker) -> AnyPublisher<Output, Failure> {
        return handleEvents(receiveCompletion: { completion in
            if case let .failure(error) = completion, let errorMessage = error as? ErrorMessage {
                errorTracker.send(errorMessage)
            }
        })
        .eraseToAnyPublisher()
    }
}
