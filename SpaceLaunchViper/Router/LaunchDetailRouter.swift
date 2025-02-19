//
//  LaunchDetailRouter.swift
//  SpaceLaunchViper
//
//  Created by Rafet Can AKAY on 4.02.2025.
//
// LaunchDetailRouter.swift

import UIKit

typealias EntryPointForDetail = LaunchDetailViewProtocol & UIViewController

protocol LaunchDetailRouterProtocol {
    var entry: EntryPointForDetail? { get }
    static func startExecutionForDetail(for launch: Launch) -> LaunchDetailRouterProtocol
}

class LaunchDetailRouter: LaunchDetailRouterProtocol {
    
    var entry: EntryPointForDetail?
    
    static func startExecutionForDetail(for launch: Launch) -> LaunchDetailRouterProtocol {
        let router = LaunchDetailRouter()
        
        // Create View, Presenter, and Interactor
        var view: LaunchDetailViewProtocol = LaunchDetailViewController()
        var presenter: LaunchDetailPresenterProtocol = LaunchDetailPresenter()
        var interactor: LaunchDetailInteractorProtocol = LaunchDetailInteractor()
        
        // Inject launch data into presenter
        presenter.launch = launch
        
        // Set up dependencies
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor // a call exist in didset be sure to launch and view setted before
        interactor.presenter = presenter
        
        // Assign the entry point (view controller) to the router
        router.entry = view as? EntryPointForDetail
        
        return router
    }
}
