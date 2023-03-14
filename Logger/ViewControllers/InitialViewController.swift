//
//  ViewController.swift
//  Logger
//
//  Created by Andres Marquez on 2023-03-04.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkAuthentification()
    }
    
    private func checkAuthentification() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let viewController = LogInViewController()
            let navigation = UINavigationController(rootViewController: viewController)
            navigation.modalPresentationStyle = .fullScreen
            present(navigation, animated: false)
        } else {
            let viewController = ProfileViewController()
            let navigation = UINavigationController(rootViewController: viewController)
            navigation.modalPresentationStyle = .fullScreen
            present(navigation, animated: false)
        }
    }
}

