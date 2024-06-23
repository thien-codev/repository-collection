//
//  CoreDataGithubRepoModelMapping.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 23/11/2023.
//

import Foundation
import CoreData

extension RepositoryEntity {
    var toGithubRepoModel: GithubRepoModel? {
        guard let fullName,
              let htmlURL else { return nil }
        return GithubRepoModel(id: Int(repoID), name: .init(), fullName: fullName, owner: .init(login: .init(), id: .zero, nodeID: .init(), avatarURL: nil), htmlURL: URL(string: htmlURL), description: description, url: nil, createdAt: createdAt ?? .init(), updatedAt: .init(), pushedAt: .init(), visibility: visibility ?? "")
    }
}

extension Array where Element == GithubRepoModel {
    func toEntity(in context: NSManagedObjectContext, userID: String) -> UserEntity {
        let userEntity: UserEntity = .init(context: context)

        userEntity.userID = userID
        
        forEach { item in
            let repositoryEntity: RepositoryEntity = .init(context: context)
            repositoryEntity.fullName = item.fullName
            repositoryEntity.htmlURL = item.htmlURL?.absoluteString
            repositoryEntity.descriptionAttr = item.description
            repositoryEntity.gitURL = item.gitURL?.absoluteString
            repositoryEntity.createdAt = item.createdAt
            repositoryEntity.visibility = item.visibility
            repositoryEntity.repoID = Int32(item.id)
            repositoryEntity.ofUser = userEntity
            
            userEntity.addToRepositories(repositoryEntity)
        }
        
        return userEntity
    }
}
