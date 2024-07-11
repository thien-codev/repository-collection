//
//  UserEventUIModel.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 11/07/2024.
//

import Foundation

protocol UserEventUIModel {
    var type: UserEventType { get }
    var createdDate: Date? { get }
}

extension UserEventModel: UserEventUIModel {
    var createdDate: Date? {
        createdAt.toDate
    }
}
