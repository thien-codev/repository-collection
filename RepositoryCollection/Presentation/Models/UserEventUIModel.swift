//
//  UserEventUIModel.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 11/07/2024.
//

import Foundation

struct UserEventUIModel: Identifiable, Hashable {
    let id = UUID()
    let types: [UserEventType]
    let createdDate: Date
    let message: String
}

protocol SingleUserEventDisplayModel {
    var type: UserEventType { get }
    var createdDate: Date? { get }
    var message: String { get }
}

extension UserEventModel: SingleUserEventDisplayModel {
    var createdDate: Date? {
        return createdAt.toDate
    }
}
