//
//  WhoIsPayViewModel.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 17.11.2023.
//


import UIKit

protocol WhoIsPayViewModelProtocol {
    var view: WhoIsPayViewProtocol? { get set}
    func numberOfUsers() -> Int
    func fechtUsers(transactionId: String)
    func viewDidLoad()
    func cellForItem(at indexPath: IndexPath) -> (User,UIColor)
    func didSelectItem(at indexPath: IndexPath)
}

final class WhoIsPayViewModel: WhoIsPayViewModelProtocol {
    var users = [User]()
    weak var view: WhoIsPayViewProtocol?
    weak var delegate: DidSelectUserProtocol?
    
    var selectedUser = ""
    func viewDidLoad() {
        view?.prepareView()
    }
    
    func cellForItem(at indexPath: IndexPath) -> (User, UIColor) {
        let user =  users[indexPath.item]
        if selectedUser == user.id {
            return (user,UIColor.white)
        } else {
            return (user,UIColor.lightGray)
        }
    }
    
    func fechtUsers(transactionId: String) {
        UserService.shared.fetchUsers(transactionId: transactionId) { result, error in
            if let error = error { return }
            self.users.removeAll()
            guard let userList = result else { return }
            self.users = userList
            
            self.view?.reloadData()
        }
    }

    func didSelectItem(at indexPath: IndexPath)  {
        let user = users[indexPath.item]
        if selectedUser == user.id { selectedUser = "" } else { selectedUser = user.id }
        
        delegate?.didSelectWhoIsPayUser(user: user,isSelected: !selectedUser.isEmpty )
        view?.reloadData()
    }
    
    func numberOfUsers() -> Int {
        users.count
    }
}
