//
//  Dictionary.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 22/11/2023.
//

import Foundation

extension Dictionary {
    
    var queryString: String? {
        var component = URLComponents()
        component.queryItems = map { URLQueryItem(name: "\($0)", value: "\($1)") }
        return component.query?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
