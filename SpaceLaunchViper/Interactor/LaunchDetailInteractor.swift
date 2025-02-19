//
//  LaunchDetailInteractor.swift
//  SpaceLaunchViper
//
//  Created by Rafet Can AKAY on 4.02.2025.
//

import Foundation
import Alamofire


protocol LaunchDetailInteractorProtocol {
    
    var presenter : LaunchDetailPresenterProtocol? {get set}
    
    func fetchLaunchDetail(id: String)
    
}

class LaunchDetailInteractor : LaunchDetailInteractorProtocol {
    
    var presenter: LaunchDetailPresenterProtocol?
    

    // Fetch Launch details for a specific launch ID
    func fetchLaunchDetail(id: String) {
        
        let urlstring = "https://api.spacexdata.com/v4/launches/\(id)"
        
        guard let url = URL(string: urlstring) else {
            presenter?.interactorLaunchInfoReceived(result: .failure(NetworkError.InvalidUrl))
               return
           }
           
        
        AF.request(url).responseDecodable(of: Launch.self) { response in
                switch response.result {
                case .success(let launch):
                    self.presenter?.interactorLaunchInfoReceived(result: .success(launch))

                case .failure(let error):
                    if let statusCode = response.response?.statusCode, statusCode == 429 {
                        self.presenter?.interactorLaunchInfoReceived(result: .failure(NetworkErrorForDetail.RateLimitExceeded))
                    } else {
                        self.presenter?.interactorLaunchInfoReceived(result: .failure(NetworkErrorForDetail.NetworkFailed))
                    }
                }
        }
        
      
    }
    
}


