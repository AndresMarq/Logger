//
//  RegisterViewController.swift
//  Logger
//
//  Created by Andres Marquez on 2023-03-06.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)
    
    private let userImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.circle"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tappedChangePic), for: .touchUpInside)
        return button
    }()
    
    private let firstNameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "First Name"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.gray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        return field
    }()

    private let lastNameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Last Name"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.gray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private let emailTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.gray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        return field
    }()

    private let passwordTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.gray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        return field
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Confirm password"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.gray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Create Account"
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Add image button on top of the view
        let size = view.width / 3
        userImageButton.frame = CGRect(
            x: (view.width - size) / 2,
            y: 100,
            width: size,
            height: size
        )
        userImageButton.layer.cornerRadius = userImageButton.width / 2
        view.addSubview(userImageButton)
        
        // Add first name
        firstNameTextField.frame = CGRect(
            x: view.width * 0.1,
            y: userImageButton.bottom + 30,
            width: view.width * 0.8,
            height: 50
        )
        firstNameTextField.delegate = self
        view.addSubview(firstNameTextField)
        
        // Add last name
        lastNameTextField.frame = CGRect(
            x: view.width * 0.1,
            y: firstNameTextField.bottom + 30,
            width: view.width * 0.8,
            height: 50
        )
        lastNameTextField.delegate = self
        view.addSubview(lastNameTextField)
        
        // Add e-mail text field
        emailTextField.frame = CGRect(
            x: view.width * 0.1,
            y: lastNameTextField.bottom + 30,
            width: view.width * 0.8,
            height: 50
        )
        emailTextField.delegate = self
        view.addSubview(emailTextField)
        
        // Add password text field
        passwordTextField.frame = CGRect(
            x: view.width * 0.1,
            y: emailTextField.bottom + 30,
            width: view.width * 0.8,
            height: 50
        )
        passwordTextField.delegate = self
        view.addSubview(passwordTextField)
        
        // Add confirm password text field
        confirmPasswordTextField.frame = CGRect(
            x: view.width * 0.1,
            y: passwordTextField.bottom + 30,
            width: view.width * 0.8,
            height: 50
        )
        confirmPasswordTextField.delegate = self
        view.addSubview(confirmPasswordTextField)
        
        // Add Log In Button
        registerButton.frame = CGRect(
            x: (view.width / 2) - (view.width * 0.125),
            y: confirmPasswordTextField.bottom + 30,
            width: view.width * 0.25,
            height: 50
        )
        view.addSubview(registerButton)
    }
    
    @objc private func registerButtonTapped() {
        guard let user = validatedInputs(), let password = passwordTextField.text else {
            return
        }
        
        spinner.show(in: view)
        
        // Check if user already exists in Database
        DatabaseManager.shared.userExists(email: user.email, completion: { [weak self] exists in
            DispatchQueue.main.async {
                self?.spinner.dismiss()
            }
            
            if exists {
                self?.registrationError(message: "Email already being used")
                return
            }
        })
        
        // If the user doesn't exists, add it to Database
        FirebaseAuth.Auth.auth().createUser(withEmail: user.email, password: password, completion: { [weak self] result, error in
            guard result != nil, error == nil else {
                self?.registrationError(message: "Could not connect with database, please try again later")
                return
            }
            
            DatabaseManager.shared.addUser(user: user, completion: { success in
                if success {
                    // Upload image
                    guard let image = self?.userImageButton.imageView?.image, let data = image.pngData() else {
                        return
                    }
                    
                    let filename = user.profilePictureFileName
                    
                    // Call storage manager to upload the image
                }
            })
            
            // Dismiss
            self?.navigationController?.dismiss(animated: true)
        })
    }
    
    // Returns user if all inputs are valid, otherwise returns nil
    private func validatedInputs() -> User? {
        // Ensures valid e-mail and password fields
        guard let firstName = firstNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text,
              let lastName = lastNameTextField.text,
              !firstName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty,
              !lastName.isEmpty else {
            self.view.endEditing(true)
            registrationError(message: "All fields are required for registration")
            return nil
        }
        
        if passwordTextField == confirmPasswordTextField {
            return User(firstName: firstName, lastName: lastName, id: UUID(), email: email)
        } else {
            registrationError(message: "Password fields do not match")
            return nil
        }
    }
    
    private func registrationError(message: String) {
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    @objc private func tappedChangePic() {
        showPictureActionSheet()
    }
}

// Ensure textfields return and continue properly
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            registerButtonTapped()
        }
        return true
    }
}

// Get results from user taking picture or selecting photo from library
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    // Called when user takes or select photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.userImageButton.setImage(image, for: .normal)
    }
    
    // Called when cancel taking picture or photo selection
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
