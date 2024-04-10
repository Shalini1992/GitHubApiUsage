//
//  PersistanceStorage.swift
//  GitHubApiUsage
//
//  Created by Admin on 10/04/24.
//

import Foundation
import CoreData

final class PersistanceStorage {
    
    private init(){}
    static let shared = PersistanceStorage()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "GitHubApiUsage")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    lazy var context = persistentContainer.viewContext
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchManagedObject<T:NSManagedObject> (managedObject: T.Type) -> [T]?
    { 
        do {
        guard  let result = try PersistanceStorage.shared.context.fetch(managedObject.fetchRequest()) as? [T] else { return nil }
            
            return result
        
        }catch  {
            return nil
            
        }
    }
}


