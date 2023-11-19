//
//  CreateBillViewModel.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 6.11.2023.
//

import Foundation
import UIKit

protocol CreateBillViewModelProtocol {
    var view: CreateBillViewProtocol? { get set }
    func viewDidLoad()
    func fechtUsers()
    func createNewBill()
    func createBillImage(imageData: Data)
    func numberOfUsers() -> Int
    func cellForItem(at indexPath:IndexPath) -> User
    func didSelectItem(at indexPath: IndexPath)
    func didSelectWhoIsPayUser(user: User)
    func updateUserCheckBox(user: User)
}

final class CreateBillViewModel {
    weak var view: CreateBillViewProtocol?
    var selectedUsers: [String] = []
    var bill = Bill()
    var users = [User]()
    
    func viewDidLoad() {
        view?.prepareView()
    }
    
    func fechtUsers() {
        UserService.shared.fechtUsers { result, error in
            if let error = error { print(error); return }
            if let users = result {
                self.users.removeAll()
                self.users = users
            }
        }
        view?.reloadData()
    }
    
    func createNewBill() {
        BillService.shared.createBill(bill: bill)
    }
    
    func createBillImage(imageData: Data) {
        ImageHelper().createAndReturnURL(fileName: UUID().uuidString
                                         , data: imageData) { (url) in
            guard let url = url else { return }
            self.bill.imageUrl = url
        }
    }
    
    func numberOfUsers() -> Int {
        users.count
    }
    
    func cellForItem(at indexPath:IndexPath) -> User {
        var user = users[indexPath.item]

        if selectedUsers.contains(user.id) {
            user.isChecked = true
        }
        return user
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let user = users[indexPath.item]
        bill.splitUser?.append(user)
    }
    
    func didSelectWhoIsPayUser(user: User,isSelected: Bool) {
        if isSelected {
            bill.payingUser = user
            bill.splitUser?.append(user)
            selectedUsers.append(user.id)
        } else {
            bill.payingUser = nil
            bill.splitUser?.removeAll(where: { $0.id == user.id })
            selectedUsers.removeAll(where: { $0 == user.id })
        }
        view?.reloadData()
    }
    
    func updateUserCheckBox(user: User) {
        if user.isChecked {
            bill.splitUser?.append(user)
            selectedUsers.append(user.id)
        } else {
            bill.splitUser?.removeAll { $0.id == user.id }
            selectedUsers.removeAll { $0 == user.id }
        }
        view?.reloadData()
    }
}
