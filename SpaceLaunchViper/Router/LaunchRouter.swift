//
//  LaunchRouter.swift
//  SpaceLaunchViper
//
//  Created by Rafet Can AKAY on 3.02.2025.
//

import UIKit

typealias EntryPoint = LaunchViewProtocol & UIViewController

protocol LaunchRouterProtocol {
    var entry : EntryPoint? {get}
    static func startExecutionForMain() -> LaunchRouterProtocol

}

class LaunchRouter : LaunchRouterProtocol {
    
    var entry: EntryPoint?
    
    static func startExecutionForMain() -> LaunchRouterProtocol {
        
        let router = LaunchRouter()
        
        var view : LaunchViewProtocol =  LaunchViewController()
        var presenter : LaunchPresenterProtocol = LaunchPresenter()
        var interactor : LaunchInteractorProtocol = LaunchInteractor()
        
        //view's presenter is presenter
        view.presenter = presenter
      
        //presenter's view, routuer and interactor arrange
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        
        router.entry = view as? EntryPoint
        
        return router
    }
    
   
}
