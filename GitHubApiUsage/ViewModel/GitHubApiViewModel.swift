//
//  GitHubApiViewModel.swift
//  GitHubApiUsage
//
//  Created by Admin on 09/04/24.
//

import Foundation
import Combine
import Alamofire

class GitHubApiViewModel: NSObject, ObservableObject{
    
    @Published var issues = [GitHubIssuesModel]()
    var page = 0
    var state = IssuesState.open
    
    init(state: IssuesState) {
        self.state = state
    }
    
    func getIssues() async throws{
        
       do {
           let url = "https://api.github.com/repos/alamofire/alamofire/issues?per_page=\(10)&page=\(page)&state=\(state.rawValue)"
           print(url)
           let request = try URLRequest(url: url, method: .get, headers: ["Accept":"application/vnd.github.full+json"])
           let (data, r) = try await URLSession.shared.data(for: request)
           guard let response = r as? HTTPURLResponse, response.statusCode == 200  else {
               throw Errors.issues
           }
           
           let decoder = JSONDecoder()
           
           if let issuesResultResult = try? decoder.decode( [GitHubIssuesModel].self, from: data){
               issues.append(contentsOf: issuesResultResult)
               page += 1
           }else{
               throw Errors.issues
           }
       } catch {
           throw Errors.issues
       }
    }
    
}


enum Errors: Error {
    case issues
}


enum IssuesState: String{
    case open, closed
}
