//
//  CreateUserViewModel.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 6.11.2023.
//

import FirebaseFirestore
protocol CreateUserViewModelProtocol {
    var view: CreateUserViewProtocol? { get set }
    func viewDidLoad()
    func createUser(user: User,imageData: Data)
    func createUserImage(imageData: Data)
}

final class CreateUserViewModel:CreateUserViewModelProtocol {
    
   weak var view: CreateUserViewProtocol?
    
    var imageUrl = ""
    var isImageSelected = false
    
    func viewDidLoad() {
        view?.viewDidLoad()
    }
    func createUser(user: User,imageData: Data) {
        UserService.shared.createUser(user: user, isImageSelected: isImageSelected, imageUrl: imageUrl, imageData: imageData)
    }
    func createUserImage(imageData: Data) {
        ImageHelper().createAndReturnURL(fileName: UUID().uuidString, data: imageData) { (url) in
            guard let url = url else { return }
            self.imageUrl = url
        }
    }
}
