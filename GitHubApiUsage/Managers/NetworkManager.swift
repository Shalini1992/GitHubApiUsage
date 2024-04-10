//
//  NetworkManager.swift
//  GitHubApiUsage
//
//  Created by Admin on 10/04/24.
//

import Foundation
import Combine
import Alamofire


enum DemoError:Error {
    case BadURL
    case NoData
    case DecodeError
    case InvalidStatusCode
    case InvalidError

}


class NetworkManager {
    
    let aPIHandle:APIHandlerDelegate
    let responseHandler:ResponseHanderDelegate
    init(aPIHandler:APIHandlerDelegate = APIHandler(),
         responseHandler:ResponseHanderDelegate = ResponseHander()){
        self.aPIHandle = aPIHandler
        self.responseHandler = responseHandler
    }
    
    func fetchRequest(url: URL, completion: @escaping(Result<[GitHubIssuesModel], DemoError>) -> Void) async throws {
        
        do {
            
            try await aPIHandle.fetchData(url: url) { result in
                switch result {
                case .success(let data):
                    self.responseHandler.fetchModel(data: data) { decodedResult in
                        
                        switch decodedResult {
                        case .success(let model):
                            print("model is \(model)")
                            completion(.success(model))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case.failure(let error):
                    completion(.failure(error))
                }
            }
        }catch {
            
        }
    }
    
    
}



protocol APIHandlerDelegate {
    func fetchData(url: URL, completion: @escaping(Result<Data, DemoError>) -> Void) async throws
    
}


class APIHandler:APIHandlerDelegate {
    
    
    func fetchData(url: URL, completion: @escaping (Result<Data, DemoError>) -> Void) async throws {
        
        
        let request = try URLRequest(url: url, method: .get, headers: ["Accept":"application/vnd.github.full+json"])
        let (data, r) = try await URLSession.shared.data(for: request)
        guard let response = r as? HTTPURLResponse, response.statusCode == 200  else {
            throw DemoError.InvalidStatusCode
        }
        
        completion(.success(data))
        
    }
    
    
}

protocol ResponseHanderDelegate {
    func fetchModel(data:Data,completion:@escaping(Result<[GitHubIssuesModel],DemoError>)-> Void)
}

class ResponseHander:ResponseHanderDelegate {
    func fetchModel(data: Data, completion: @escaping (Result<[GitHubIssuesModel], DemoError>) -> Void) {
        
        let response =  try? JSONDecoder().decode([GitHubIssuesModel].self,from:data)
        if let response = response {
            completion(.success(response))
        }else {
            completion(.failure(.DecodeError))
        }
        
    }
    
    
}

