//
//  GitHubRepoModel.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation

// MARK: - GitHubRepoModel
struct GitHubRepoModel: Decodable {
    let id: Int
    let name, fullName: String
    let fork: Bool
    let owner: Owner
    let htmlURL: URL?
    let description: String?
    let url: URL?
    let createdAt, updatedAt, pushedAt: String?
    let gitURL, sshURL: URL?
    let cloneURL: URL?
    let language: String?
    let stargazersCount: Int
    let visibility: String
    let watchersCount: Int
    let forksCount: Int
    let topics: [String]
    let isTemplate: Bool
    let archived: Bool
    let disabled: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case fork
        case htmlURL = "html_url"
        case description, url
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
        case gitURL = "git_url"
        case sshURL = "ssh_url"
        case cloneURL = "clone_url"
        case stargazersCount = "stargazers_count"
        case language
        case visibility
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case topics
        case isTemplate = "is_template"
        case archived
        case disabled
    }
    
    init(id: Int,
         name: String,
         fullName: String,
         owner: Owner,
         htmlURL: URL? = nil,
         description: String?,
         fork: Bool = false,
         url: URL? = nil,
         createdAt: String? = nil,
         updatedAt: String? = nil,
         pushedAt: String? = nil,
         gitURL: URL? = nil,
         sshURL: URL? = nil,
         cloneURL: URL? = nil,
         language: String? = nil,
         stargazersCount: Int = 0,
         watchersCount: Int = 0,
         forksCount: Int = 0,
         visibility: String,
         topics: [String] = [],
         isTemplate: Bool = false,
         archived: Bool = false,
         disabled: Bool = false
    ) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.owner = owner
        self.htmlURL = htmlURL
        self.description = description
        self.url = url
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.pushedAt = pushedAt
        self.gitURL = gitURL
        self.sshURL = sshURL
        self.cloneURL = cloneURL
        self.language = language
        self.visibility = visibility
        self.topics = topics
        self.fork = fork
        self.stargazersCount = stargazersCount
        self.watchersCount = watchersCount
        self.forksCount = forksCount
        self.isTemplate = isTemplate
        self.archived = archived
        self.disabled = disabled
    }
}

extension GitHubRepoModel: Equatable {
    
    static func == (lhs: GitHubRepoModel, rhs: GitHubRepoModel) -> Bool {
        return lhs.id == rhs.id && lhs.fullName == rhs.fullName && lhs.gitURL == rhs.gitURL
    }
}

extension Array where Element == GitHubRepoModel {
    var owner: Owner? {
        return self.first?.owner
    }
}

// MARK: - Owner
struct Owner: Decodable, Equatable {
    
    let login: String
    let id: Int
    let nodeID: String?
    let avatarURL: String?
    let gravatarID: String?
    let url, htmlURL, followersURL: String?
    let followingURL: String?
    let gistsURL: String?
    let starredURL: String?
    let subscriptionsURL, organizationsURL, reposURL: String?
    let eventsURL: String?
    let receivedEventsURL: String?
    let type: String?
    let siteAdmin: Bool?
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
}

