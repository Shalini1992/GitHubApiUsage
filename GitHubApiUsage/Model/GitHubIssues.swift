//
//  GitHubIssues.swift
//  GitHubApiUsage
//
//  Created by Admin on 09/04/24.
//

import Foundation

// MARK: - GitHubIssuesModelElement
struct GitHubIssuesModel: Codable {
    let url, repositoryURL: String?
    let labelsURL: String?
    let commentsURL, eventsURL, htmlURL: String?
    let id: Int?
    let nodeID: String?
    let number: Int?
    let title: String?
    let user: User?
    let state: String?
    let locked: Bool?
    let comments: Int?
    let createdAt, updatedAt: String?
    let authorAssociation: String?
    let draft: Bool?
    let pullRequest: PullRequest?
    let body: String?
    let body_html:String?
    let reactions: Reactions?
    let timelineURL: String?

    enum CodingKeys: String, CodingKey {
        case url
        case repositoryURL
        case labelsURL
        case commentsURL
        case eventsURL
        case htmlURL
        case id
        case nodeID
        case number, title, user, state, locked, comments
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case authorAssociation
        case draft
        case pullRequest
        case body,body_html, reactions
        case timelineURL
    }
}


// MARK: - PullRequest
struct PullRequest: Codable {
    let url, htmlURL: String?
    let diffURL: String?
    let patchURL: String?

    enum CodingKeys: String, CodingKey {
        case url
        case htmlURL
        case diffURL
        case patchURL
    }
}

// MARK: - Reactions
struct Reactions: Codable {
    let url: String?
    let totalCount, the1, reactions1, laugh: Int?
    let hooray, confused, heart, rocket: Int?
    let eyes: Int?

    enum CodingKeys: String, CodingKey {
        case url
        case totalCount
        case the1
        case reactions1
        case laugh, hooray, confused, heart, rocket, eyes
    }
}

// MARK: - User
struct User: Codable {
    let login: String?
    let id: Int?
    let nodeID: String?
    let avatarURL: String?
    let gravatarID: String?
    let url, htmlURL, followersURL: String?
    let followingURL, gistsURL, starredURL: String?
    let subscriptionsURL, organizationsURL, reposURL: String?
    let eventsURL: String?
    let receivedEventsURL: String?
    let type: String?
    let siteAdmin: Bool?

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID
        case avatarURL
        case gravatarID
        case url
        case htmlURL
        case followersURL
        case followingURL
        case gistsURL
        case starredURL
        case subscriptionsURL
        case organizationsURL
        case reposURL
        case eventsURL
        case receivedEventsURL
        case type
        case siteAdmin
    }
}

