//
//  CDGitHubIssues+CoreDataProperties.swift
//  GitHubApiUsage
//
//  Created by Admin on 10/04/24.
//
//

import Foundation
import CoreData


extension CDGitHubIssues {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDGitHubIssues> {
        return NSFetchRequest<CDGitHubIssues>(entityName: "CDGitHubIssues")
    }

    @NSManaged public var id: Int64
    @NSManaged public var number: Int64
    @NSManaged public var title: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var body_html: String?
    @NSManaged public var state: String?
    
    func convertToGitHubIssue () -> GitHubIssuesModel {
        return GitHubIssuesModel(id: Int(self.id), number: Int(self.number), title: self.title, user: nil, createdAt: self.createdAt, body_html: self.body_html, state: self.state)
        
    }

}

extension CDGitHubIssues : Identifiable {

}
