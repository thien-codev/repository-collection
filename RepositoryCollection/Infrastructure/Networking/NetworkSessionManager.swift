//
//  NetworkSessionManager.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation
import Alamofire

public protocol ErrorMessage {
    var description: String? { get }
}

protocol NetworkCancellable {
    func doCancel()
}

protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, ErrorMessage?) -> Void
    
    func request(_ url: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable
}

extension DataRequest: NetworkCancellable {
    func doCancel() {
        cancel()
    }
}

final class AFNetworkSessionManager: NetworkSessionManager {
    
    func request(_ url: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        AF.request(url)
            .validate()
            .responseData { response in
                switch response.result {
                case let .success(data):
                    completion(data, nil, nil)
                case let .failure(error):
                    completion(nil, nil, error)
                }
            }
    }
}

extension AFError: ErrorMessage {
    public var description: String? {
        return errorDescription
    }
}
