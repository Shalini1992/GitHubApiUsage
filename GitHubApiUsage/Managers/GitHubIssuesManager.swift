//
//  GitHubIssuesManager.swift
//  GitHubApiUsage
//
//  Created by Admin on 10/04/24.
//

import Foundation
import CoreData

struct GitHubIssuesManager {
    
    private let _gitHubissueDataRepository = GithubIssuesDataRepository()
    
    func createGithubIssue(githubIssue: GitHubIssuesModel){
        
        return _gitHubissueDataRepository.createIssue(githubIssue: githubIssue)
    }
    
    func fetchGitHubIssues() -> [GitHubIssuesModel]? {
      
        return _gitHubissueDataRepository.getAll()
            
    }
    
    
    func fetchGitHubIssue(byIdentifier id: Int64) -> GitHubIssuesModel? {
    
        return _gitHubissueDataRepository.get(byIdentifier: id)
    }
    
    func  updateGithubIssue(githubIssue: GitHubIssuesModel) -> Bool{
        
        return _gitHubissueDataRepository.updateIssue(githubIssue: githubIssue)
        
    }
    
    func deleteGitHubIssue(githubIssue: GitHubIssuesModel) -> Bool {
        
        return _gitHubissueDataRepository.deleteIssue(githubIssue: githubIssue)
        
    }

}
