//
//  NetworkService.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation

enum NetworkError: Error, ErrorMessage {
    case notConnected
    case cancelled
    case generic(ErrorMessage)
    case urlGeneration
    
    var description: String? {
        switch self {
        case .notConnected:
            return "No connection"
        case .cancelled:
            return "Request cancelled"
        case .generic(let errorMessage):
            return errorMessage.description
        case .urlGeneration:
            return "Generate URL failed"
        }
    }
}

protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable?
}

final class DefaultNetworkService: NetworkService {
    
    private let networkSessionManager: NetworkSessionManager
    private var currentTask: NetworkCancellable?
    
    init(networkSessionManager: NetworkSessionManager) {
        self.networkSessionManager = networkSessionManager
    }
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable? {
        guard let urlRequest = endpoint.urlRequest else {
            completion(.failure(.urlGeneration))
            return nil
        }
        
        currentTask?.doCancel()
        currentTask = networkSessionManager.request(urlRequest) { data, _, requestError in
            if let requestError {
                completion(.failure(.generic(requestError)))
            } else {
                completion(.success(data))
            }
        }
        
        return currentTask
    }
}

