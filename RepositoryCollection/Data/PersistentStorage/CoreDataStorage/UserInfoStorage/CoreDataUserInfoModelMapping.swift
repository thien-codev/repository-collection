//
//  CoreDataUserInfoModelMapping.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 07/07/2024.
//

import Foundation
import CoreData

extension UserInfoEntity {
    var toUserInfoModel: GitHubUserModel? {
        guard let login,
              let avatarURL else { return nil }
        
        return GitHubUserModel(login: login,
                               id: Int(userID),
                               nodeID: nodeID ?? "",
                               avatarURL: avatarURL,
                               gravatarID: "",
                               url: url,
                               htmlURL: htmlURL,
                               followersURL: followersURL,
                               followingURL: followingURL,
                               gistsURL: gistsURL,
                               starredURL: starredURL,
                               subscriptionsURL: subscriptionsURL,
                               organizationsURL: organizationsURL,
                               reposURL: reposURL,
                               eventsURL: eventsURL,
                               receivedEventsURL: "",
                               type: nil,
                               siteAdmin: false,
                               name: name,
                               company: company,
                               blog: blog,
                               location: blog,
                               email: email,
                               hireable: true,
                               bio: bio,
                               twitterUsername: twitterUsername,
                               publicRepos: Int(publicRepos),
                               publicGists: Int(publicGists),
                               followers: Int(followers),
                               following: Int(following),
                               createdAt: createdAt,
                               updatedAt: updatedAt,
                               privateGists: Int(privateGists),
                               totalPrivateRepos: Int(totalPrivateRepos),
                               ownedPrivateRepos: Int(ownedPrivateRepos),
                               diskUsage: Int(diskUsage),
                               collaborators: Int(collaborators),
                               twoFactorAuthentication: nil,
                               plan: nil)
    }
}

extension GitHubUserModel {
    func toEntity(in context: NSManagedObjectContext) -> UserInfoEntity {
        let entity: UserInfoEntity = .init(context: context)
        
        entity.login = login
        entity.userID = Int64(id)
        entity.nodeID = nodeID
        entity.avatarURL = avatarURL
        entity.url = url
        entity.htmlURL = htmlURL
        entity.followersURL = followersURL
        entity.followingURL = followingURL
        entity.gistsURL = gistsURL
        entity.starredURL = starredURL
        entity.subscriptionsURL = subscriptionsURL
        entity.organizationsURL = organizationsURL
        entity.reposURL = reposURL
        entity.eventsURL = eventsURL
        entity.name = name
        entity.company = company
        entity.blog = blog
        entity.location = location
        entity.email = email
        entity.bio = bio
        entity.twitterUsername = twitterUsername
        entity.publicRepos = Int64(publicRepos)
        entity.publicGists = Int64(publicGists)
        entity.followers = Int64(followers)
        entity.following = Int64(following)
        entity.createdAt = createdAt
        entity.updatedAt = updatedAt
        entity.privateGists = Int64(privateGists ?? 0)
        entity.totalPrivateRepos = Int64(totalPrivateRepos ?? 0)
        entity.ownedPrivateRepos = Int64(ownedPrivateRepos ?? 0)
        entity.diskUsage = Int64(diskUsage ?? 0)
        entity.collaborators = Int64(collaborators ?? 0)
        
        return entity
    }
}
