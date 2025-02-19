//
//  LaunchDetailViewController.swift
//  SpaceLaunchViper
//
//  Created by Rafet Can AKAY on 3.02.2025.
//
import Foundation
import UIKit

protocol LaunchDetailViewProtocol {
    
    var presenter : LaunchDetailPresenterProtocol? {get set}
    
    func displayDetailLaunch(launch: Launch)
    
    func displayError(message: String)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
}

class LaunchDetailViewController: UIViewController,LaunchDetailViewProtocol {
    
    var presenter: LaunchDetailPresenterProtocol?
    
    func displayDetailLaunch(launch: Launch) {
        showLaunchDetail(detail: launch)
    }
    
    func displayError(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            
        // Add a dismiss action to close the alert
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(dismissAction)
            
        // Present the alert
        present(alert, animated: true, completion: nil)

        
    }

    
    func showLoadingIndicator(){
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator(){
        loadingIndicator.stopAnimating()
    }
    
    
    var detailpresenter: LaunchDetailPresenter?
    
    var launchDetail: Launch?
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .gray
        spinner.hidesWhenStopped = true
        return spinner
    }()

    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .white
        return label
    }()
    
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .white
        return label
    }()
    
    private let patchImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    private let youtubeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.backgroundColor = UIColor.red.cgColor
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Watch on YouTube", for: .normal)
        button.isHidden = true
        return button
    }()
    
  
    private let pressKitButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.backgroundColor = UIColor.blue.cgColor
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Download Press Kit", for: .normal)
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
    
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        patchImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(patchImageView)
       
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        youtubeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(youtubeButton)
        
        pressKitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pressKitButton)
        
        youtubeButton.addTarget(self, action: #selector(openYouTube), for: .touchUpInside)
        pressKitButton.addTarget(self, action: #selector(openPressKit), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            patchImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            patchImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            patchImageView.heightAnchor.constraint(equalToConstant: 100),
            patchImageView.widthAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: patchImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            youtubeButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            youtubeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            youtubeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            pressKitButton.topAnchor.constraint(equalTo: youtubeButton.bottomAnchor, constant: 20),
            pressKitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pressKitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        // Add loading indicator to the view
        view.addSubview(loadingIndicator)
            
        // Set up constraints for the loading indicator to be centered
        NSLayoutConstraint.activate([
                loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
       
    }
    
    func showLaunchDetail(detail: Launch) {
        launchDetail = detail
        nameLabel.text = detail.name
        dateLabel.text = detail.date
        
        if let details = detail.details {
            descriptionLabel.text = details
        } else {
            descriptionLabel.text = ""
            descriptionLabel.isHidden = true
        }
        
        if let patchURLString = detail.links.patch?.large, let patchURL = URL(string: patchURLString) {
            downloadImage(from: patchURL)
        } else if let patchURLString = detail.links.patch?.small, let patchURL = URL(string: patchURLString) {
            downloadImage(from: patchURL)
        } else {
            patchImageView.image = UIImage(named: "placeholderlaunch")
        }
        
        // Show or hide the buttons based on availability of links
        youtubeButton.isHidden = detail.links.youtubeid == nil
        pressKitButton.isHidden = detail.links.presskitlink == nil
    }
    
    func downloadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self?.patchImageView.image = UIImage(data: data)
                }
            } else {
                DispatchQueue.main.async {
                    self?.patchImageView.image = UIImage(named: "placeholderlaunch")
                }
            }
        }
        task.resume()
    }
    
    @objc func openYouTube() {
        print("launchDetail?  \(launchDetail)")
        print("launchDetail?.links.youtubeid  \(launchDetail?.links.youtubeid)")
        print("launchDetail?.links  \(launchDetail?.links)")
        guard let youtubeID = launchDetail?.links.youtubeid else { return }
        if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeID)") {
            UIApplication.shared.open(youtubeURL)
        }
    }
    
    @objc func openPressKit() {
        guard let pressKitLink = launchDetail?.links.presskitlink else { return }
        if let pressKitURL = URL(string: pressKitLink) {
            UIApplication.shared.open(pressKitURL)
        }
    }
}
