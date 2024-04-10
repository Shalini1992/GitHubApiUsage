//
//  GitHubIssues.swift
//  GitHubApiUsage
//
//  Created by Admin on 09/04/24.
//

import Foundation

// MARK: - GitHubIssuesModelElement
struct GitHubIssuesModel: Codable {
    let id: Int?
    let number: Int?
    let title: String?
    let user: User?
    let createdAt:String?
    let body_html:String?
    let state:String?

    enum CodingKeys: String, CodingKey {
        case id
        case number, title, user
        case createdAt = "created_at"
        case body_html
        case state
    }
}


// MARK: - User
struct User: Codable {
    let login: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case login, id
      
    }
}

