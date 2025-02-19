//
//  MainViewController.swift
//  SpaceLaunchViper
//
//  Created by Rafet Can AKAY on 3.02.2025.
//

import Foundation
import UIKit
import Alamofire
import UIKit
import UIKit


protocol LaunchViewProtocol {
    
    var presenter : LaunchPresenterProtocol? {get set}
    
    func displayLaunches(launches: [Launch])
    
    func displayError(message: String)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
}


class LaunchViewController: UIViewController, LaunchViewProtocol, UITableViewDelegate, UITableViewDataSource {
    
    private let reuseIdentifierForCell = "LaunchCell"
 
    var launches: [Launch] = []
    
    var presenter: LaunchPresenterProtocol?
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .gray
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    func showLoadingIndicator(){
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator(){
        loadingIndicator.stopAnimating()
    }
    
    private var tableView : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        table.separatorStyle = .none
        return table
    }()
    
    private let messageLabel : UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .white
        return label
    }()
    
    private let segmentedControlForTableView: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Past","Future"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .gray
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        control.selectedSegmentTintColor = .black
        return control
    }()
    
    @objc private func segmentChanged() {
        if segmentedControlForTableView.selectedSegmentIndex == 0 {
            showLoadingIndicator()
            (presenter?.interactor as? LaunchInteractor)?.fetchLaunches(type: .past)
        } else {
            showLoadingIndicator()
            (presenter?.interactor as? LaunchInteractor)?.fetchLaunches(type: .upcoming)
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(messageLabel)
        view.addSubview(tableView)
        view.addSubview(segmentedControlForTableView)
        segmentedControlForTableView.isHidden = true
        segmentedControlForTableView.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LaunchCell.self, forCellReuseIdentifier: reuseIdentifierForCell)
        tableView.isHidden = true
      
        
        // Add loading indicator to the view
        view.addSubview(loadingIndicator)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Setup Segment Control, TableView, and Layout as before
        
        segmentedControlForTableView.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 10, width: view.frame.width - 20, height: 30)
     
        tableView.frame = CGRect(x: 0, y: segmentedControlForTableView.frame.maxY + 10, width: view.frame.width, height: view.frame.height - segmentedControlForTableView.frame.maxY - 10)
        
        
        messageLabel.frame = CGRect(x: 0, y: view.frame.height / 2, width: view.frame.width, height: 50)
        
        // Set up constraints for the loading indicator to be centered
        NSLayoutConstraint.activate([
                loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    func displayLaunches(launches: [Launch]) {
        DispatchQueue.main.async {
            self.launches = launches
            self.tableView.reloadData()
            
            self.tableView.isHidden = false
            self.segmentedControlForTableView.isHidden = false
        
            self.messageLabel.isHidden = true
        }
    }
    
    
    func displayError(message: String) {
        DispatchQueue.main.async {
            
            // Show error to the user (perhaps in an alert)
            self.messageLabel.text = message
            self.messageLabel.isHidden = false
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // Adjust the height as needed
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchCell", for: indexPath) as! LaunchCell
        let launch = launches[indexPath.row]
        
        cell.launchNameLabel.text = launch.name
        cell.launchDateLabel.text = launch.date
        
        // Download the image
        if let patchURLString = launch.links.patch?.small, let patchURL = URL(string: patchURLString) {
            cell.downloadImage(from: patchURL)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let launch = launches[indexPath.row]
        showLaunchDetail(for: launch)
        
        tableView.deselectRow(at: indexPath, animated: true) // Deselect the row

    }
    
    
    func showLaunchDetail(for launch: Launch) {
           // Create a router instance
           let router = LaunchDetailRouter.startExecutionForDetail(for: launch)
           
           // Retrieve the entry point (the view controller)
           if let launchDetailVC = router.entry {
               // Present the view controller
               self.present(launchDetailVC, animated: true,completion: nil)
           }
       }
    
}
