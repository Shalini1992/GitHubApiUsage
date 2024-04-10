//
//  GitHubApiViewModel.swift
//  GitHubApiUsage
//
//  Created by Admin on 09/04/24.
//

import Foundation

class GitHubApiViewModel: NSObject, ObservableObject{
    
    @Published var issues = [GitHubIssuesModel]()
    var page = 0
    var state = IssuesState.open
    
    let serviceHandler: ServiceHandlerDelegate

    
    init(state: IssuesState,serviceHandler: ServiceHandlerDelegate = ServiceHandler()) {
        self.state = state
        self.serviceHandler = serviceHandler

    }
//    
//    func getIssues() async throws{
//        
//       do {
//           let url = "https://api.github.com/repos/alamofire/alamofire/issues?per_page=\(10)&page=\(page)&state=\(state.rawValue)"
//           print(url)
//           let request = try URLRequest(url: url, method: .get, headers: ["Accept":"application/vnd.github.full+json"])
//           let (data, r) = try await URLSession.shared.data(for: request)
//           guard let response = r as? HTTPURLResponse, response.statusCode == 200  else {
//               throw Errors.issues
//           }
//           
//           let decoder = JSONDecoder()
//           
//           if let issuesResultResult = try? decoder.decode( [GitHubIssuesModel].self, from: data){
//               issues.append(contentsOf: issuesResultResult)
//               page += 1
//           }else{
//               throw Errors.issues
//           }
//       } catch {
//           throw Errors.issues
//       }
//    }
    
    
    func getIssuesUsingNetworkManagerClass() async throws{
        
        guard let url = URL(string: "https://api.github.com/repos/alamofire/alamofire/issues?per_page=\(10)&page=\(page)&state=\(state.rawValue)") else {
            throw Errors.issues
        }
       
        
        do {
            try await serviceHandler.fetchGitHubIssues(url: url) { result in
                DispatchQueue.main.async { [self] in
                    switch result {
                    case .success(let gitHubIssues):
                        print("Fetched new comments")
                        self.issues.append(contentsOf: gitHubIssues)
                        page += 1

                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
        }catch {
            
        }
        
    }
    
}




enum Errors: Error {
    case issues
}


enum IssuesState: String{
    case open, closed
}
