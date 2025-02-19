//
//  LaunchPresenter.swift
//  SpaceLaunchViper
//
//  Created by Rafet Can AKAY on 3.02.2025.
//

import Foundation
import Foundation

enum NetworkError : Error {
    case NetworkFailed
    case ParsingFailed
    case RateLimitExceeded
    case InvalidUrl
}


protocol LaunchPresenterProtocol {
    var router : LaunchRouterProtocol? {get set}
    
    var interactor : LaunchInteractorProtocol? {get set}
    
    var view : LaunchViewProtocol? {get set}
    
    func interactorLaunchesReceived(result: Result<[Launch], Error>)
}

class LaunchPresenter : LaunchPresenterProtocol {
  
    
    var router: LaunchRouterProtocol?
    
    var interactor: LaunchInteractorProtocol? {
        didSet {
            view?.showLoadingIndicator()
            interactor?.fetchLaunches(type: .past)
        }
    }
    
    var view: LaunchViewProtocol?
    
    func interactorLaunchesReceived(result: Result<[Launch], Error>) {
        switch result {
            case .success(let launches):
                //view.update
                if launches.count > 0 {
                    view?.displayLaunches(launches: launches)
                }else {
                    view?.displayError(message: "No Data")
                }
                
            case .failure(let error):
                //error
                // Determine the error type and set a custom message
                let errorMessage: String
                        
                if let networkError = error as? NetworkError {
                    switch networkError {
                        case .NetworkFailed:
                            errorMessage = "Network connection failed. Please check your internet and try again."
                        case .ParsingFailed:
                                errorMessage = "Data parsing error. Please report this issue."
                        case .RateLimitExceeded:
                            errorMessage = "Too many requests! Please wait and try again later."
                        case .InvalidUrl:
                            errorMessage = "Invalid Url!"
                    }
                } else {
                    errorMessage = "An unknown error occurred. Please try again."
                }
                    
                // Pass the custom error message to the view
                view?.displayError(message: errorMessage)

        }
        view?.hideLoadingIndicator()
    }
    

    
    
   
}
