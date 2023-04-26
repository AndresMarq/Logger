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
    /*
    private let userImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.circle"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tappedChangePic), for: .touchUpInside)
        return button
    }()
     */
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width / 2
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(tappedChangePic)))
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size = view.width / 3
        /*
        userImageButton.frame = CGRect(
            x: (view.width - size) / 2,
            y: 100,
            width: size,
            height: size
        )
        userImageButton.layer.cornerRadius = userImageButton.width / 2
        view.addSubview(userImageButton)
        */
        
        profileImageView.frame = CGRect(x: (view.width - 150) / 2, y: 75, width: 150, height: 150)
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
    
    @objc private func tappedChangePic() {
        showPictureActionSheet()
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showPictureActionSheet() {
        let sheet = UIAlertController(title: "Select Profile Picture", message: "Preferred method", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            self?.useCamera()
        }))
        sheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { [weak self] _ in
            self?.useLibrary()
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(sheet, animated: true)
    }
    
    func useCamera() {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = self
        controller.allowsEditing = true
        present(controller, animated: true)
    }
    
    func useLibrary() {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        controller.allowsEditing = true
        present(controller, animated: true)
    }
    
    func uploadProfilePicture(image: UIImage) {
        guard let data = image.pngData(), let email = UserDefaults.standard.string(forKey: "email") else {
            return
        }
        
        let databaseEmail = DatabaseManager.databaseEmail(email: email)
        let filename = databaseEmail + "_profile_picture.png"
        
        StorageManager.shared.uploadProfilePicture(with: data, filename: filename, completion: { [weak self] result in
            switch result {
            case .success(let downloadURL):
                guard let url = URL(string: downloadURL) else { return }
                DispatchQueue.main.async {
                    self?.profileImageView.sd_setImage(with: url)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    // Called when user takes or select photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        uploadProfilePicture(image: image)
    }
    
    // Called when cancel taking picture or photo selection
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func downloadURL(for email: String?) {
        guard let safeEmail = email else { return }
        let databaseEmail = DatabaseManager.databaseEmail(email: safeEmail)
        let filename = databaseEmail + "_profile_picture.png"
        
        let path = "images/" + filename
        
        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async { [weak self] in
                    self?.profileImageView.sd_setImage(with: url)
                }
                
            case .failure(let error):
                print("Failed to get download URL: \(error)")
            }
        })
    }
}

