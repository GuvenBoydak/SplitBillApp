//
//  User.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 6.11.2023.
//

import Foundation

struct User {
    var id: String
    var firstname: String
    var lastname: String
    var email: String
    var imageUrl: String
    
    
    init(id: String, firstname: String, lastname: String, email: String, imageUrl: String) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.imageUrl = imageUrl
    }
}
