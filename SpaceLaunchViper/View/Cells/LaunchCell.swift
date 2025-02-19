//
//  LaunchCell.swift
//  SpaceLaunchViper
//
//  Created by Rafet Can AKAY on 3.02.2025.
//
import UIKit
import UIKit

class LaunchCell: UITableViewCell {
    
    var launchNameLabel: UILabel!
    var launchDateLabel: UILabel!
   
    private let patchImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.image = UIImage(named: "placeholderlaunch")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        
        backgroundColor = .white
        
        // Create Image View
        patchImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true // Set fixed width
        patchImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true // Set fixed height

        // Create Launch Name Label
        launchNameLabel = UILabel()
        launchNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        launchNameLabel.textColor = .black
        launchNameLabel.numberOfLines = 1

        // Create Launch Date Label
        launchDateLabel = UILabel()
        launchDateLabel.font = UIFont.systemFont(ofSize: 14)
        launchDateLabel.textColor = .darkGray
        launchDateLabel.numberOfLines = 1

        // Vertical StackView for Labels
        let labelsStackView = UIStackView(arrangedSubviews: [launchNameLabel, launchDateLabel])
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .leading
        labelsStackView.spacing = 4

        // Horizontal StackView for Image + Labels
        let mainStackView = UIStackView(arrangedSubviews: [patchImageView, labelsStackView])
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.spacing = 12
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStackView)

        // Constraints for Main StackView
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
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
}
