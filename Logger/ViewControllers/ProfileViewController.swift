//
//  ProfileViewController.swift
//  Logger
//
//  Created by Andres Marquez on 2023-03-13.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ProfileViewController: UIViewController {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width / 2
        return imageView
    }()
    
    private let logOutButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        downloadURL(for: UserDefaults.standard.string(forKey: "email"))
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size = view.width / 3
        
        profileImageView.frame = CGRect(
            x: (view.width - size) / 2,
            y: 100,
            width: size,
            height: size
        )
        profileImageView.layer.cornerRadius = profileImageView.width / 2
        view.addSubview(profileImageView)
        
        logOutButton.frame = CGRect(
            x: 100,
            y: profileImageView.bottom + 100,
            width: 200,
            height: 200
        )
        view.addSubview(logOutButton)
    }
    
    @objc private func logOutTapped() {
        let ac = UIAlertController(title: "Are you sure you want to log out?", message: "", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [weak self] _ in
            
            // Log out Firebase
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                // Clear the image cache
                SDImageCache.shared.clearMemory()
                SDImageCache.shared.clearDisk()
                
                let viewController = LogInViewController()
                let navigation = UINavigationController(rootViewController: viewController)
                navigation.modalPresentationStyle = .fullScreen
                self?.present (navigation, animated: false)
            }
            catch {
                print("Error Loging Out")
                self?.logOutError(message: "Please try again later")
            }
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
}

extension ProfileViewController: UINavigationControllerDelegate {
    
    func downloadURL(for email: String?) {
        guard let safeEmail = email else { return }
        let databaseEmail = DatabaseManager.databaseEmail(email: safeEmail)
        let filename = databaseEmail + "_profile_picture.png"
        
        let path = "images/" + filename
        
        // Set a placeholder image while waiting for the new image to download
        profileImageView.image = UIImage(systemName: "person.circle")
        
        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async { [weak self] in
                    // Set the downloaded image
                    self?.profileImageView.sd_setImage(with: url)
                }
                
            case .failure(let error):
                print("Failed to get download URL: \(error)")
            }
        })
    }
    
    private func logOutError(message: String) {
        let ac = UIAlertController(title: "Log Out Error", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
}

