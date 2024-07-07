//
//  CoreDataGitHubRepoModelMapping.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 23/11/2023.
//

import Foundation
import CoreData

extension RepositoryEntity {
    var toGitHubRepoModel: GitHubRepoModel? {
        guard let fullName,
              let htmlURL,
              let name else { return nil }
        var repoTopics: [String] = []
        if let setTopics = topics as? Set<TopicEntity> {
            repoTopics = Array(setTopics).compactMap({ $0.name })
        }
        return GitHubRepoModel(id: Int(repoID), 
                               name: name,
                               fullName: fullName,
                               owner: Owner(login: "", id: 0, nodeID: "", avatarURL: "", gravatarID: "", url: "", htmlURL: "", followersURL: "", followingURL: "", gistsURL: "", starredURL: "", subscriptionsURL: "", organizationsURL: "", reposURL: "", eventsURL: "", receivedEventsURL: "", type: "", siteAdmin: true),
                               htmlURL: URL(string: htmlURL),
                               description: descriptionAttr,
                               fork: fork == true,
                               url: nil,
                               createdAt: createdAt ?? .init(),
                               updatedAt: .init(),
                               pushedAt: .init(),
                               language: language,
                               stargazersCount: Int(stargazersCount),
                               watchersCount: Int(watchersCount),
                               forksCount: Int(forksCount),
                               visibility: visibility ?? "",
                               topics: repoTopics,
                               isTemplate: isTemplate,
                               archived: archived,
                               disabled: disabled)
    }
}

extension Array where Element == GitHubRepoModel {
    func toEntity(in context: NSManagedObjectContext, userID: String) -> UserEntity {
        let userEntity: UserEntity = .init(context: context)

        userEntity.userID = userID
        
        forEach { item in
            let repositoryEntity: RepositoryEntity = .init(context: context)
            repositoryEntity.fullName = item.fullName
            repositoryEntity.name = item.name
            repositoryEntity.stargazersCount = Int16(item.stargazersCount)
            repositoryEntity.watchersCount = Int16(item.watchersCount)
            repositoryEntity.forksCount = Int16(item.forksCount)
            item.topics.forEach { topic in
                let topicEntity: TopicEntity = .init(context: context)
                topicEntity.name = topic
                repositoryEntity.addToTopics(topicEntity)
            }
            repositoryEntity.htmlURL = item.htmlURL?.absoluteString
            repositoryEntity.descriptionAttr = item.description
            repositoryEntity.gitURL = item.gitURL?.absoluteString
            repositoryEntity.createdAt = item.createdAt
            repositoryEntity.visibility = item.visibility
            repositoryEntity.language = item.language
            repositoryEntity.repoID = Int32(item.id)
            repositoryEntity.ofUser = userEntity
            repositoryEntity.isTemplate = item.isTemplate
            repositoryEntity.archived = item.archived
            repositoryEntity.disabled = item.disabled
            
            userEntity.addToRepositories(repositoryEntity)
        }
        
        return userEntity
    }
}
