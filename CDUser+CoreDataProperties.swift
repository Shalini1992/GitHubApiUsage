//
//  CDUser+CoreDataProperties.swift
//  GitHubApiUsage
//
//  Created by Admin on 10/04/24.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var id: Int64
    @NSManaged public var login: String?

}

extension CDUser : Identifiable {

}
