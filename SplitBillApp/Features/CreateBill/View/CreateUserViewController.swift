//
//  CreateUserViewController.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 5.11.2023.
//

import UIKit
protocol CreateUserViewProtocol: AnyObject {
    func prepareView()
}

final class CreateUserViewController: UIViewController {
    // MARK: - UIElements
    private let imageContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 34
        view.backgroundColor = .lightGray
        return view
    }()
    private let image: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.layer.cornerRadius = 30
        image.image = UIImage(named: "add")
        return image
    }()
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Name"
        return label
    }()
    private let nameTextField: UITextField = {
       let textField = UITextField()
        textField.autocorrectionType = .no
        textField.backgroundColor = .white
        return textField
    }()
    private let lastnameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Lastname"
        return label
    }()
    private let lastnameTextField: UITextField = {
       let textField = UITextField()
        textField.autocorrectionType = .no
        textField.backgroundColor = .white
        return textField
    }()
    private let emailLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Email"
        return label
    }()
    private let emailTextField: UITextField = {
       let textField = UITextField()
        textField.autocorrectionType = .no
        textField.backgroundColor = .white
        return textField
    }()
    private let saveButton: UIButton = {
       let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = UIColor(named: "button")
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 18
        return button
    }()
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "New User"
        return label
    }()

    // MARK: - Properties
    private lazy var createUserVM = CreateUserViewModel()
    var transactionId = ""
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createUserVM.view = self
        createUserVM.view?.prepareView()
    }
}

// MARK: - Selectors
extension CreateUserViewController {
    @objc private func saveUser() {
        guard let firstname = nameTextField.text
                ,let lastname = lastnameTextField.text
                , let email = emailTextField.text
                ,let imageData = UIImage(systemName: "person.circle")?.pngData() else { return }
        let user = User(id: ""
                        , firstname: firstname
                        , lastname: lastname
                        , email: email
                        , imageUrl: ""
                        ,isChecked: false
                        ,transactionId: transactionId )
        createUserVM.createUser(user: user, imageData: imageData)

        navigationController?.popViewController(animated: true)
    }
    @objc private func closeView() {
        dismiss(animated: true)
    }
}
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CreateUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
       let imagePickerController = UIImagePickerController()
       imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
       imagePickerController.delegate = self
       createUserVM.isImageSelected = true
       present(imagePickerController, animated: true)
   }
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       guard let image = info[.originalImage] as? UIImage
                ,let imageData = image.jpegData(compressionQuality: 1.0) else { return }
       self.image.image = image
       createUserVM.createUserImage(imageData: imageData)
       dismiss(animated: true)
   }
}

//MARK: - CreateUserViewProtocol
extension CreateUserViewController: CreateUserViewProtocol {
    func prepareView() {
        createUserVM.view = self
        style()
        layout()
        saveButton.addTarget(self
                             , action: #selector(saveUser)
                             , for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self
                                                          , action: #selector(imageTapped))
        image.addGestureRecognizer(tapGestureRecognizer)
    }
}

// MARK: - Helpers
extension CreateUserViewController {
    private func style() {
        view.backgroundColor = UIColor(named: "background")
        let views: [UIView] = [imageContainer,image,nameTextField,nameLabel,lastnameTextField,lastnameLabel,emailTextField,emailLabel,saveButton,titleLabel]
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
    }
    private func layout() {
        imageContainer.addSubview(image)
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // imageContainer and image
            imageContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            imageContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageContainer.widthAnchor.constraint(equalToConstant: 150),
            imageContainer.heightAnchor.constraint(equalToConstant: 150),
            image.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            image.widthAnchor.constraint(equalToConstant: 120),
            image.heightAnchor.constraint(equalToConstant: 120),
            //nameTextField and nameLabel
            nameTextField.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 30),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nameTextField.heightAnchor.constraint(equalToConstant: 42),
            nameLabel.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 26),
            // lastnameTextfield and lastnameLabel
            lastnameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            lastnameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            lastnameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            lastnameTextField.heightAnchor.constraint(equalToConstant: 42),
            lastnameLabel.bottomAnchor.constraint(equalTo: lastnameTextField.topAnchor, constant: 8),
            lastnameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 26),
            // emailTextField and emailLabel
            emailTextField.topAnchor.constraint(equalTo: lastnameTextField.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 42),
            emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 26),
            // saveButton
            saveButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 28),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 175),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
