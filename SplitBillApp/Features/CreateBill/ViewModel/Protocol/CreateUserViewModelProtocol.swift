//
//  CreateUserViewModelProtocol.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 6.11.2023.
//

import Foundation

protocol CreateUserViewModelProtocol {
    func createUser(user: User) 
    func updateUser(user: User)
    func fechtUsers(complation: @escaping ([User]?,Error?) -> ())
}
