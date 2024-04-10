//
//  GithubIssuesDataRepository.swift
//  GitHubApiUsage
//
//  Created by Admin on 10/04/24.
//

import Foundation
import CoreData

protocol GithubIssuesRepository {
    func createIssue(githubIssue :GitHubIssuesModel)
    func getAll() -> [GitHubIssuesModel]?
    func get(byIdentifier id: Int64) -> GitHubIssuesModel?
    func  updateIssue(githubIssue :GitHubIssuesModel) -> Bool
    func deleteIssue(githubIssue :GitHubIssuesModel) -> Bool
}


struct GithubIssuesDataRepository:GithubIssuesRepository {
    
    
    func createIssue(githubIssue: GitHubIssuesModel) {
        
        let cdGithubIssue = CDGitHubIssues(context: PersistanceStorage.shared.context)
        cdGithubIssue.id = Int64(githubIssue.id ?? 0)
        cdGithubIssue.number = Int64(githubIssue.number ?? 0)
        cdGithubIssue.createdAt = githubIssue.createdAt
        cdGithubIssue.body_html = githubIssue.body_html
        cdGithubIssue.state = githubIssue.state
        cdGithubIssue.title = githubIssue.title
        PersistanceStorage.shared.saveContext()
    }
    
    func getAll() -> [GitHubIssuesModel]? {
        
        let result =  PersistanceStorage.shared.fetchManagedObject(managedObject: CDGitHubIssues.self)

        var gitHubIssues : [GitHubIssuesModel] = []
        
        result?.forEach({(cdGitHubIssues) in
            
            gitHubIssues.append(cdGitHubIssues.convertToGitHubIssue())
            
        })
        
        
        return gitHubIssues
        
    }
    
    func get(byIdentifier id: Int64) -> GitHubIssuesModel? {
        
        let result = getGitHubIssue(byIdentifier: id)
        
        guard  result != nil else  {return nil }
        
        return result?.convertToGitHubIssue()
        
    }
    
    func updateIssue(githubIssue: GitHubIssuesModel) -> Bool{
        
        let result = getGitHubIssue(byIdentifier: Int64(githubIssue.number ?? 0))
        guard result != nil else {return false}
        
        result?.id = Int64(githubIssue.id ?? 0)
        result?.number = Int64(githubIssue.number ?? 0)
        result?.title = githubIssue.title
        result?.createdAt = githubIssue.createdAt
        result?.body_html = githubIssue.body_html
        result?.state = githubIssue.state
        PersistanceStorage.shared.saveContext()

        return true
    }
    
    func deleteIssue(githubIssue: GitHubIssuesModel) -> Bool {
        
        let cdgithubIssue = getGitHubIssue(byIdentifier: Int64(githubIssue.number ?? 0))
        guard cdgithubIssue != nil else {return false}

        PersistanceStorage.shared.context.delete(cdgithubIssue!)
        return true

    }
    
    func getGitHubIssue(byIdentifier id: Int64) -> CDGitHubIssues? {

        let fecthRequest = NSFetchRequest<CDGitHubIssues>(entityName: "CDGitHubIssues")
        let predicate = NSPredicate(format: "number==%d", id )
       
        fecthRequest.predicate = predicate
       
        do {
            let result =  try PersistanceStorage.shared.context.fetch(fecthRequest).first
            
            guard  result != nil else  {return nil }
            
            return result
            
        }catch {
           return nil
        }
    }
    
    
    
    
    
}
