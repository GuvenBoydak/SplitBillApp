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
                                     "imageURL": user.imageUrl ,
                                     "transactionId": user.transactionId ]
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
    
    func fetchUsers(transactionId: String, completion: @escaping ([User]?, Error?) -> ()) {     
        var users = [User]()
        
        FIREBASE_USER.getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(nil, nil); return
            }
            //users.removeAll()
            
            for document in documents {
                let data = document.data()
                let id = document.documentID
                let transaction = data["transactionId"] as? String ?? ""
                
                if transaction == transactionId {
                    let firstname = data["firstname"] as? String ?? ""
                    let lastname = data["lastname"] as? String ?? ""
                    
                    let email = data["email"] as? String ?? ""
                    let imageUrl = data["imageURL"] as? String ?? ""
                    let isChecked = data["isChecked"] as? Bool ?? false
                    
                    users.append(User(id: id, firstname: firstname, lastname: lastname, email: email, imageUrl: imageUrl,isChecked: isChecked,transactionId: transactionId))
                }
            }
            completion(users, nil)
        }
    }
    
    func fetchPayingUser(_ userId: String) async throws -> User? {
        let snapshot = try await FIREBASE_USER.document(userId).getDocument()

            let id = snapshot.documentID
        if let data = snapshot.data() {
            let firstname = data["firstname"] as? String ?? ""
            let lastname = data["lastname"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let imageURL = data["imageURL"] as? String ?? ""
            let isChecked = data["isChecked"] as? Bool ?? false
            let transactionId = data["transactionId"] as? String ?? ""
            
            return User(id: id, firstname: firstname, lastname: lastname, email: email, imageUrl: imageURL, isChecked: isChecked,transactionId: transactionId)
        }
        return nil
    }
    
    func fetchSplitUsers(_ userIds: [String],transactionId: String) async throws -> [User] {
        var users = [User]()
        let snapshot = try await FIREBASE_USER.getDocuments()
        users.removeAll()
        
        for document in snapshot.documents {
            let data = document.data()
            let id = document.documentID
            let transaction = data["transactionId"] as? String ?? ""
            if transactionId == transaction {
                let firstname = data["firstname"] as? String ?? ""
                let lastname = data["lastname"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let imageUrl = data["imageURL"] as? String ?? ""
                let isChecked = data["isChecked"] as? Bool ?? false
                
                users.append(User(id: id, firstname: firstname, lastname: lastname, email: email, imageUrl: imageUrl,isChecked: isChecked,transactionId: transactionId))
            }
        }
        return users
    }
}
