//
//  LaunchDetailPresenter.swift
//  SpaceLaunchViper
//
//  Created by Rafet Can AKAY on 4.02.2025.
//

import Foundation

enum NetworkErrorForDetail : Error {
    case NetworkFailed
    case InvalidUrl
    case RateLimitExceeded
}

protocol LaunchDetailPresenterProtocol {
    
    var launch: Launch? { get set } // Store the launch data
      
    var router : LaunchDetailRouterProtocol? {get set}
    
    var interactor : LaunchDetailInteractorProtocol? {get set}
    
    var view : LaunchDetailViewProtocol? {get set}
    
    func interactorLaunchInfoReceived(result: Result<Launch, Error>)
}

class LaunchDetailPresenter : LaunchDetailPresenterProtocol {

    var router: LaunchDetailRouterProtocol?
    
    var interactor: LaunchDetailInteractorProtocol? {
        didSet {
            
            view?.showLoadingIndicator()
            interactor?.fetchLaunchDetail(id: launch?.id ?? "")
        }
    }
    
    var view: LaunchDetailViewProtocol?

    var launch: Launch?
    
    func interactorLaunchInfoReceived(result: Result<Launch, Error>) {
        
        switch result {
            case .success(let launch):
                //view.update
                view?.displayDetailLaunch(launch: launch)
                
            case .failure(let error):
                //error
                // Determine the error type and set a custom message
                let errorMessage: String
                        
                if let networkError = error as? NetworkErrorForDetail {
                    switch networkError {
                        case .NetworkFailed:
                            errorMessage = "Network connection failed. Please check your internet and try again."
                        case .InvalidUrl:
                            errorMessage = "Invalid Url!"
                        case .RateLimitExceeded:
                           errorMessage = "Rating Limit!"
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
