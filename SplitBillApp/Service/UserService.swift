//
//  UserService.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 17.11.2023.
//

import Foundation

final class UserService {
    static var shared = UserService()
    
    func createUser(user: User,isImageSelected: Bool, imageUrl: String,imageData: Data) {
        var params : [String:Any] = ["id": user.id ,
                                     "firstname": user.firstname ,
                                     "lastname": user.lastname ,
                                     "email": user.email ,
                                     "isChecked": user.isChecked ,
                                     "imageURL": user.imageUrl ]
        if isImageSelected {
            params["imageURL"] = imageUrl
        } else {
            ImageHelper().createAndReturnURL(fileName: user.firstname.lowercased(), data: imageData) { url in
                if let image = url {
                    params["imageURL"] = image
                }
            }
        }
        FIREBASE_USER.addDocument(data: params) { error in
            if error != nil { print(error?.localizedDescription ?? "")}
        }
    }
    
    func fechtUsers(complation: @escaping ([User]?,Error?) -> ()) {
        FIREBASE_USER.addSnapshotListener { snapshot, error in
            if let error = error { 
                complation(nil,error);
                return }
            
            let userList: [User] = snapshot?.documents.compactMap { document in
                let data = document.data()
                let id = document.documentID
                let firstname = data["firstname"] as? String ?? ""
                let lastname = data["lastname"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let imageUrl = data["imageURL"] as? String ?? ""
                let isChecked = data["isChecked"] as? Bool ?? false
                
                return User(id: id, firstname: firstname, lastname: lastname, email: email, imageUrl: imageUrl,isChecked: isChecked)
            } ?? []
            complation(userList,nil)
        }
    }
}
