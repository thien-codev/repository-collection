//
//  UserEventModel.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 11/07/2024.
//

import Foundation

// MARK: - UserEventModel
struct UserEventModel: Decodable, Equatable {
    let id: String
    let type: UserEventType
    let actor: EventActor
    let repo: Repo
    let payload: Payload
    let welcomePublic: Bool
    let createdAt: String
    let org: Owner?

    enum CodingKeys: String, CodingKey {
        case id, type, actor, repo, payload
        case welcomePublic = "public"
        case createdAt = "created_at"
        case org
    }
    
    static func == (lhs: UserEventModel, rhs: UserEventModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension UserEventModel {
    var message: String {
        switch type {
        case .pushEvent:
            guard let commits = payload.commits else { return "" }
            return "pushed \(commits.count) commits to \(repo.name)"
        case .pullRequestEvent:
            return "created PR to \(repo.name)"
        case .issueCommentEvent:
            return "commented on \(repo.name)"
        default: return ""
        }
    }
}

// MARK: - Actor
struct EventActor: Codable, Equatable {
    let id: Int
    let login: String
    let displayLogin: String?
    let gravatarID: String
    let url, avatarURL: String

    enum CodingKeys: String, CodingKey {
        case id, login
        case displayLogin = "display_login"
        case gravatarID = "gravatar_id"
        case url
        case avatarURL = "avatar_url"
    }
}

// MARK: - Payload
struct Payload: Decodable {
    let forkee: Forkee?
    let ref: String?
    let refType: String?
    let masterBranch: String?
    let description: String?
    let pusherType: String?
    let repositoryID, pushID, size, distinctSize: Int?
    let head, before: String?
    let commits: [Commit]?
    let action: Action?
    let number: Int?
    let pullRequest: PullRequest?
    let issue: Issue?
    let comment: Comment?

    enum CodingKeys: String, CodingKey {
        case forkee, ref
        case refType = "ref_type"
        case masterBranch = "master_branch"
        case description
        case pusherType = "pusher_type"
        case repositoryID = "repository_id"
        case pushID = "push_id"
        case size
        case distinctSize = "distinct_size"
        case head, before, commits, action, number
        case pullRequest = "pull_request"
        case issue, comment
    }
}

enum Action: String, Decodable {
    case closed = "closed"
    case created = "created"
    case opened = "opened"
    case started = "started"
}

// MARK: - Comment
struct Comment: Decodable {
    let url, htmlURL, issueURL: String
    let id: Int
    let nodeID: String?
    let user: Owner
    let createdAt, updatedAt: String
    let authorAssociation, body: String
    let reactions: Reactions
    let performedViaGithubApp: String?

    enum CodingKeys: String, CodingKey {
        case url
        case htmlURL = "html_url"
        case issueURL = "issue_url"
        case id
        case nodeID = "node_id"
        case user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case authorAssociation = "author_association"
        case body, reactions
        case performedViaGithubApp = "performed_via_github_app"
    }
}

// MARK: - Reactions
struct Reactions: Decodable {
    let url: String
    let totalCount, the1, reactions1, laugh: Int
    let hooray, confused, heart, rocket: Int
    let eyes: Int

    enum CodingKeys: String, CodingKey {
        case url
        case totalCount = "total_count"
        case the1 = "+1"
        case reactions1 = "-1"
        case laugh, hooray, confused, heart, rocket, eyes
    }
}

// MARK: - Commit
struct Commit: Decodable {
    let sha: String
    let author: Author
    let message: String
    let distinct: Bool
    let url: String
}

// MARK: - Author
struct Author: Decodable {
    let email, name: String
}

// MARK: - Forkee
struct Forkee: Decodable {
    let id: Int
    let nodeID, name, fullName: String?
    let forkeePrivate: Bool
    let owner: Owner
    let htmlURL: String
    let description: String?
    let fork: Bool
    let url: String
    let forksURL: String
    let keysURL, collaboratorsURL: String
    let teamsURL, hooksURL: String
    let issueEventsURL: String
    let eventsURL: String
    let assigneesURL, branchesURL: String
    let tagsURL: String
    let blobsURL, gitTagsURL, gitRefsURL, treesURL: String
    let statusesURL: String
    let languagesURL, stargazersURL, contributorsURL, subscribersURL: String
    let subscriptionURL: String
    let commitsURL, gitCommitsURL, commentsURL, issueCommentURL: String
    let contentsURL, compareURL: String
    let mergesURL: String
    let archiveURL: String
    let downloadsURL: String
    let issuesURL, pullsURL, milestonesURL, notificationsURL: String
    let labelsURL, releasesURL: String
    let deploymentsURL: String
    let createdAt, updatedAt, pushedAt: String
    let gitURL, sshURL: String
    let cloneURL: String
    let svnURL: String
    let homepage: String?
    let size, stargazersCount, watchersCount: Int
    let language: String?
    let hasIssues, hasProjects, hasDownloads, hasWiki: Bool
    let hasPages, hasDiscussions: Bool
    let forksCount: Int
    let mirrorURL: String?
    let archived, disabled: Bool
    let openIssuesCount: Int
    let license: License?
    let allowForking, isTemplate, webCommitSignoffRequired: Bool
    let topics: [String]
    let visibility: String
    let forks, openIssues, watchers: Int
    let defaultBranch: String
    let forkeePublic: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case forkeePrivate = "private"
        case owner
        case htmlURL = "html_url"
        case description, fork, url
        case forksURL = "forks_url"
        case keysURL = "keys_url"
        case collaboratorsURL = "collaborators_url"
        case teamsURL = "teams_url"
        case hooksURL = "hooks_url"
        case issueEventsURL = "issue_events_url"
        case eventsURL = "events_url"
        case assigneesURL = "assignees_url"
        case branchesURL = "branches_url"
        case tagsURL = "tags_url"
        case blobsURL = "blobs_url"
        case gitTagsURL = "git_tags_url"
        case gitRefsURL = "git_refs_url"
        case treesURL = "trees_url"
        case statusesURL = "statuses_url"
        case languagesURL = "languages_url"
        case stargazersURL = "stargazers_url"
        case contributorsURL = "contributors_url"
        case subscribersURL = "subscribers_url"
        case subscriptionURL = "subscription_url"
        case commitsURL = "commits_url"
        case gitCommitsURL = "git_commits_url"
        case commentsURL = "comments_url"
        case issueCommentURL = "issue_comment_url"
        case contentsURL = "contents_url"
        case compareURL = "compare_url"
        case mergesURL = "merges_url"
        case archiveURL = "archive_url"
        case downloadsURL = "downloads_url"
        case issuesURL = "issues_url"
        case pullsURL = "pulls_url"
        case milestonesURL = "milestones_url"
        case notificationsURL = "notifications_url"
        case labelsURL = "labels_url"
        case releasesURL = "releases_url"
        case deploymentsURL = "deployments_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
        case gitURL = "git_url"
        case sshURL = "ssh_url"
        case cloneURL = "clone_url"
        case svnURL = "svn_url"
        case homepage, size
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language
        case hasIssues = "has_issues"
        case hasProjects = "has_projects"
        case hasDownloads = "has_downloads"
        case hasWiki = "has_wiki"
        case hasPages = "has_pages"
        case hasDiscussions = "has_discussions"
        case forksCount = "forks_count"
        case mirrorURL = "mirror_url"
        case archived, disabled
        case openIssuesCount = "open_issues_count"
        case license
        case allowForking = "allow_forking"
        case isTemplate = "is_template"
        case webCommitSignoffRequired = "web_commit_signoff_required"
        case topics, visibility, forks
        case openIssues = "open_issues"
        case watchers
        case defaultBranch = "default_branch"
        case forkeePublic = "public"
    }
}

// MARK: - License
struct License: Codable {
    let key: String
    let name: String
    let spdxID: String
    let url: String
    let nodeID: String

    enum CodingKeys: String, CodingKey {
        case key, name
        case spdxID = "spdx_id"
        case url
        case nodeID = "node_id"
    }
}

// MARK: - Issue
struct Issue: Decodable {
    let url, repositoryURL: String
    let labelsURL: String
    let commentsURL, eventsURL, htmlURL: String
    let id: Int
    let nodeID: String?
    let number: Int
    let title: String
    let user: Owner
    let labels: [Label]
    let state: String
    let locked: Bool
    let assignee: Owner?
    let assignees: [Owner]
    let milestone: Milestone?
    let comments: Int
    let createdAt, updatedAt: String
    let closedAt: String?
    let authorAssociation: String
    let activeLockReason: String?
    let body: String
    let reactions: Reactions
    let timelineURL: String
    let performedViaGithubApp, stateReason: String?

    enum CodingKeys: String, CodingKey {
        case url
        case repositoryURL = "repository_url"
        case labelsURL = "labels_url"
        case commentsURL = "comments_url"
        case eventsURL = "events_url"
        case htmlURL = "html_url"
        case id
        case nodeID = "node_id"
        case number, title, user, labels, state, locked, assignee, assignees, milestone, comments
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case closedAt = "closed_at"
        case authorAssociation = "author_association"
        case activeLockReason = "active_lock_reason"
        case body, reactions
        case timelineURL = "timeline_url"
        case performedViaGithubApp = "performed_via_github_app"
        case stateReason = "state_reason"
    }
}

// MARK: - Milestone
struct Milestone: Decodable {
    let url, htmlURL, labelsURL: String
    let id: Int
    let nodeID: String
    let number: Int
    let title, description: String
    let creator: Owner
    let openIssues, closedIssues: Int
    let state: String
    let createdAt, updatedAt: String
    let dueOn: String?
    let closedAt: String?

    enum CodingKeys: String, CodingKey {
        case url
        case htmlURL = "html_url"
        case labelsURL = "labels_url"
        case id
        case nodeID = "node_id"
        case number, title, description, creator
        case openIssues = "open_issues"
        case closedIssues = "closed_issues"
        case state
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case dueOn = "due_on"
        case closedAt = "closed_at"
    }
}

// MARK: - Label
struct Label: Decodable {
    let id: Int
    let nodeID: String?
    let url: String
    let name, color: String
    let labelDefault: Bool
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case url, name, color
        case labelDefault = "default"
        case description
    }
}

// MARK: - PullRequest
struct PullRequest: Decodable {
    let url: String
    let id: Int
    let nodeID: String?
    let htmlURL: String
    let diffURL: String
    let patchURL: String
    let issueURL: String
    let number: Int
    let state: String
    let locked: Bool
    let title: String
    let user: Owner
    let body: String?
    let createdAt, updatedAt: String
    let closedAt, mergedAt: String?
    let mergeCommitSHA: String?
    let assignee: Owner?
    let assignees, requestedReviewers: [Owner]
    let labels: [Label]
    let milestone: Milestone?
    let draft: Bool
    let commitsURL, reviewCommentsURL: String
    let reviewCommentURL: String
    let commentsURL, statusesURL: String
    let head, base: Base
    let links: Links
    let authorAssociation: String
    let autoMerge, activeLockReason: String?
    let merged: Bool
    let mergeable, rebaseable: Bool?
    let mergeableState: String
    let mergedBy: Owner?
    let comments, reviewComments: Int
    let maintainerCanModify: Bool
    let commits, additions, deletions, changedFiles: Int

    enum CodingKeys: String, CodingKey {
        case url, id
        case nodeID = "node_id"
        case htmlURL = "html_url"
        case diffURL = "diff_url"
        case patchURL = "patch_url"
        case issueURL = "issue_url"
        case number, state, locked, title, user, body
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case closedAt = "closed_at"
        case mergedAt = "merged_at"
        case mergeCommitSHA = "merge_commit_sha"
        case assignee, assignees
        case requestedReviewers = "requested_reviewers"
        case labels, milestone, draft
        case commitsURL = "commits_url"
        case reviewCommentsURL = "review_comments_url"
        case reviewCommentURL = "review_comment_url"
        case commentsURL = "comments_url"
        case statusesURL = "statuses_url"
        case head, base
        case links = "_links"
        case authorAssociation = "author_association"
        case autoMerge = "auto_merge"
        case activeLockReason = "active_lock_reason"
        case merged, mergeable, rebaseable
        case mergeableState = "mergeable_state"
        case mergedBy = "merged_by"
        case comments
        case reviewComments = "review_comments"
        case maintainerCanModify = "maintainer_can_modify"
        case commits, additions, deletions
        case changedFiles = "changed_files"
    }
}

// MARK: - Base
struct Base: Decodable {
    let label, ref, sha: String
    let user: Owner
    let repo: Forkee
}

// MARK: - Links
struct Links: Decodable {
    let linksSelf, html, issue, comments: Comments
    let reviewComments, reviewComment, commits, statuses: Comments

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, issue, comments
        case reviewComments = "review_comments"
        case reviewComment = "review_comment"
        case commits, statuses
    }
}

// MARK: - Comments
struct Comments: Decodable {
    let href: String
}

// MARK: - Repo
struct Repo: Decodable, Equatable {
    let id: Int
    let name: String
    let url: String
}

enum UserEventType: String, Decodable, Equatable {
    case createEvent = "CreateEvent"
    case forkEvent = "ForkEvent"
    case issueCommentEvent = "IssueCommentEvent"
    case issuesEvent = "IssuesEvent"
    case pullRequestEvent = "PullRequestEvent"
    case pushEvent = "PushEvent"
    case watchEvent = "WatchEvent"
    case publicEvent = "PublicEvent"
    case deleteEvent = "DeleteEvent"
    case commitCommentEvent = "CommitCommentEvent"
    case gollumEvent = "GollumEvent"
    
    case MemberEvent = "MemberEvent"
    case PullRequestReviewEvent = "PullRequestReviewEvent"
    case PullRequestReviewCommentEvent = "PullRequestReviewCommentEvent"
    case PullRequestReviewThreadEvent = "PullRequestReviewThreadEvent"
    case ReleaseEvent = "ReleaseEvent"
    case SponsorshipEvent = "SponsorshipEvent"
    
    var title: String {
        switch self {
        case .createEvent:
            "created repositories"
        case .forkEvent:
            "forked"
        case .issueCommentEvent:
            "comments on other repositories"
        case .issuesEvent:
            "issues from other repositories"
        case .pullRequestEvent:
            "created pull request to other repositories"
        case .pushEvent:
            "pushed commits to other repositories"
        case .watchEvent:
            "watched repository"
        case .publicEvent:
            "public repository"
        case .deleteEvent:
            "deleted repository"
        case .commitCommentEvent:
            "commited comments"
        case .gollumEvent:
            "gollumed "
        case .MemberEvent:
            "member"
        case .PullRequestReviewEvent:
            "pulled request review"
        case .PullRequestReviewCommentEvent:
            "pulled request review comment"
        case .PullRequestReviewThreadEvent:
            "pulled request review thread"
        case .ReleaseEvent:
            "release"
        case .SponsorshipEvent:
            "got sponsorship"
        }
    }
    
    var isContributedEvent: Bool {
        return [.issueCommentEvent, .pullRequestEvent, .pushEvent].contains(self)
    }
}
