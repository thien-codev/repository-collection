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
    let owner: Owner
    let htmlURL: String
    let description: String?
    let url: String
    let createdAt, updatedAt, pushedAt: String
    let gitURL, sshURL: String
    let cloneURL: String
    let language: String?
    let visibility: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case htmlURL = "html_url"
        case description, url
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
        case gitURL = "git_url"
        case sshURL = "ssh_url"
        case cloneURL = "clone_url"
        case language
        case visibility
    }
}

extension GithubRepoModel: Equatable {
    
    static func == (lhs: GithubRepoModel, rhs: GithubRepoModel) -> Bool {
        return lhs.id == rhs.id && lhs.fullName == rhs.fullName && lhs.gitURL == rhs.gitURL
    }
}

// MARK: - Owner
struct Owner: Decodable {
    
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

