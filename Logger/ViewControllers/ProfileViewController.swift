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
    
    private let logOutButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        button.backgroundColor = .white
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .red
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logOutButton.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        view.addSubview(logOutButton)
    }
    
    @objc func logOutTapped() {
        let ac = UIAlertController(title: "Are you sure you want to log out?", message: "", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [weak self] _ in
            
            // Log out Firebase
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                let viewController = LogInViewController()
                let navigation = UINavigationController(rootViewController: viewController)
                navigation.modalPresentationStyle = .fullScreen
                self?.present (navigation, animated: false)
            }
            catch {
                print("opps")
                // MARK: -Implement log out error func
            }
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
}
