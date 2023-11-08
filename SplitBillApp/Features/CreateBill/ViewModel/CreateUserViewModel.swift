//
//  CreateUserViewModel.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 6.11.2023.
//

import FirebaseFirestore

final class CreateUserViewModel {
    
    
}
// MARK: - CreateUserViewModelProtocol
extension CreateUserViewModel: CreateUserViewModelProtocol {
    func updateUser(user: User) {
        let params : [String:Any] = ["id": user.id,
                                     "firstname": user.firstname,
                                     "lastname": user.lastname,
                                     "email": user.email,
                                     "isChecked": false,
                                     "imageURL": user.imageUrl]
        return FIREBASE_USER.document(user.id).setData(params, merge: true)
    }
    
    func createUser(user: User) -> String {
        let params : [String:Any] = ["id":"",
                                     "firstname":user.firstname,
                                     "lastname":user.lastname,
                                     "email":user.email,
                                     "isChecked":false,
                                     "imageURL":user.imageUrl]
        return FIREBASE_USER.addDocument(data: params) { error in
            if error != nil { print(error?.localizedDescription ?? "")}
        }.documentID
    }
    
    func fechtUsers(complation: @escaping ([User]?,Error?) -> ()) {
        FIREBASE_USER.getDocuments { snapshot, error in
            if let error = error { complation(nil,error); return}
            let userList: [User] = snapshot?.documents.compactMap { document in
                       let data = document.data()
                       let id = document.documentID
                       let firstname = data["firstname"] as? String ?? ""
                       let lastname = data["lastname"] as? String ?? ""
                       let email = data["email"] as? String ?? ""
                       let imageUrl = data["imageURL"] as? String ?? ""
                
                       return User(id: id, firstname: firstname, lastname: lastname, email: email, imageUrl: imageUrl)
                   } ?? []
            complation(userList,nil)
        }
    }
    
}
