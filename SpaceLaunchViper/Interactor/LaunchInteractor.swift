//
//  LaunchInteractor.swift
//  SpaceLaunchViper
//
//  Created by Rafet Can AKAY on 3.02.2025.
//

import Foundation

import Alamofire

enum LaunchEndpoint {
    case past
    case upcoming
    
    // URL for the API requests
    var url: URL {
        switch self {
        case .past:
            return URL(string: "https://api.spacexdata.com/v4/launches/past")!
        case .upcoming:
            return URL(string: "https://api.spacexdata.com/v4/launches/upcoming")!
        }
    }
}

protocol LaunchInteractorProtocol {
    
    var presenter : LaunchPresenterProtocol? {get set}
    
    func fetchLaunches(type: LaunchEndpoint)
    
    
}

class LaunchInteractor : LaunchInteractorProtocol {
    
    
    var presenter: LaunchPresenterProtocol?
    
    static let shared = LaunchInteractor()
    
    // Fetch upcoming or past launches
    func fetchLaunches(type: LaunchEndpoint) {
    
        let urlstring: String
        switch type {
        case .upcoming:
            urlstring = "https://api.spacexdata.com/v4/launches/upcoming"
        case .past:
            urlstring = "https://api.spacexdata.com/v4/launches/past"
        }
        
        guard let url = URL(string: urlstring) else {
            presenter?.interactorLaunchesReceived(result: .failure(NetworkError.InvalidUrl))
               return
           }
           
        
        AF.request(url).responseDecodable(of: [Launch].self) { response in
                switch response.result {
                case .success(let launches):
                    self.presenter?.interactorLaunchesReceived(result: .success(launches))

                case .failure(let error):
                    if let statusCode = response.response?.statusCode, statusCode == 429 {
                        self.presenter?.interactorLaunchesReceived(result: .failure(NetworkError.RateLimitExceeded))
                    } else {
                       self.presenter?.interactorLaunchesReceived(result: .failure(NetworkError.ParsingFailed))
                    }
                }
        }
        
    }
    
}
