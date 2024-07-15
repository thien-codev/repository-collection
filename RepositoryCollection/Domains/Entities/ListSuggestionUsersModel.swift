//
//  ListSuggestionUsersModel.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 15/07/2024.
//

import Foundation

struct ListSuggestionUsersModel: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Owner]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
