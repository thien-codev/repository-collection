//
//  GithubRepoModel.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation

struct GithubRepoModel: Decodable {
    let id: Int
    let name, fullName: String
    let fork: Bool
    let owner: Owner
    let htmlURL: URL?
    let description: String?
    let url: URL?
    let createdAt, updatedAt, pushedAt: String
    let gitURL, sshURL: URL?
    let cloneURL: URL?
    let language: String?
    let stargazersCount: Int
    let visibility: String
    let topics: [String]

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
        case topics
    }
    
    init(id: Int,
         name: String,
         fullName: String,
         owner: Owner,
         htmlURL: URL? = nil,
         description: String?,
         fork: Bool = false,
         url: URL? = nil,
         createdAt: String,
         updatedAt: String,
         pushedAt: String,
         gitURL: URL? = nil,
         sshURL: URL? = nil,
         cloneURL: URL? = nil,
         language: String? = nil,
         stargazersCount: Int = 0,
         visibility: String,
         topics: [String] = []) {
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
    }
}

extension GithubRepoModel: Equatable {
    
    static func == (lhs: GithubRepoModel, rhs: GithubRepoModel) -> Bool {
        return lhs.id == rhs.id && lhs.fullName == rhs.fullName && lhs.gitURL == rhs.gitURL
    }
}

extension Array where Element == GithubRepoModel {
    var owner: Owner? {
        return self.first?.owner
    }
}

// MARK: - Owner
struct Owner: Decodable, Equatable {
    
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String?
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
    }
}

