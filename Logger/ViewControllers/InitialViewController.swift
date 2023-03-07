//
//  ViewController.swift
//  Logger
//
//  Created by Andres Marquez on 2023-03-04.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let viewController = LogInViewController()
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: false)
    }
}

