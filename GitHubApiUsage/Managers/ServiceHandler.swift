//
//  ServiceHandler.swift
//  GitHubApiUsage
//
//  Created by Admin on 10/04/24.
//

import Foundation

protocol ServiceHandlerDelegate {
    func fetchGitHubIssues(url:URL, completion: @escaping(Result<[GitHubIssuesModel], DemoError>) -> Void) async throws
}

class ServiceHandler: ServiceHandlerDelegate  {
    
    func fetchGitHubIssues(url:URL, completion: @escaping(Result<[GitHubIssuesModel], DemoError>) -> Void) async throws {
        
        do {
            try await NetworkManager().fetchRequest(url: url, completion: completion)
            
        }catch {
            throw DemoError.InvalidError
        }
       
    }
    
}


