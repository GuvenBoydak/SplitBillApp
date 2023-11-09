//
//  WhoIsPayViewController.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 5.11.2023.
//

import UIKit


final class WhoIsPayViewController: UICollectionViewController {
    // MARK: - UIElements

    // MARK: - Properties
    var userList: [User]? {
       didSet {
           reloadCollectionView()
        }
    }
    var createUserVM = CreateUserViewModel()
    weak var delegate: DidSelectUserProtocol?
    var selectedUser = ""
    // MARK: - Life Cycle
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        super.init(collectionViewLayout: flowLayout)
        style()
        
        createUserVM.fechtUsers { response, error in
            if error != nil { print(error?.localizedDescription ?? ""); return}
            if let users = response {
                self.userList = users
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Helpers
extension WhoIsPayViewController {
    private func style() {
        collectionView.layer.cornerRadius = 30
        collectionView.backgroundColor = .lightGray
        collectionView.register(WhoIsPayCell.self, forCellWithReuseIdentifier: WhoIsPayCell.WhoIsPayIdentifier.custom.rawValue)
    }
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
// MARK: - UICollectionViewDataSource
extension WhoIsPayViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let users = userList else { return 0 }
        return users.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WhoIsPayCell.WhoIsPayIdentifier.custom.rawValue, for: indexPath) as! WhoIsPayCell
        if let user = userList?[indexPath.item] {
            cell.user = user;
            if selectedUser == user.id{
                cell.cellContainer.backgroundColor = .white
            } else {
                cell.cellContainer.backgroundColor = .lightGray
            }
        }
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = userList?[indexPath.item] else { return}
        if selectedUser == user.id { selectedUser = "" } else { selectedUser = user.id }
        delegate?.didSelectWhoIsPayUser(user: user)
        reloadCollectionView()
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension WhoIsPayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 72 , height: 100)
    }
}
