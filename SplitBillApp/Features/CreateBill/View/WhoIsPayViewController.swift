//
//  WhoIsPayViewController.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 5.11.2023.
//

import UIKit
protocol WhoIsPayViewProtocol: AnyObject {
    func prepareView()
    func reloadData()
}

final class WhoIsPayViewController: UICollectionViewController {
    // MARK: - UIElements

    // MARK: - Properties
     lazy var whoIsPayVM = WhoIsPayViewModel()
    
    // MARK: - Life Cycle
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        super.init(collectionViewLayout: flowLayout)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        whoIsPayVM.view = self
        whoIsPayVM.viewDidLoad()
    }
}

// MARK: - UICollectionViewDataSource
extension WhoIsPayViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        whoIsPayVM.numberOfUsers()
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WhoIsPayCell.WhoIsPayIdentifier.custom.rawValue, for: indexPath) as! WhoIsPayCell
        let userAndColor: (User,UIColor) = whoIsPayVM.cellForItem(at: indexPath)

        cell.user = userAndColor.0
        cell.cellContainer.backgroundColor = userAndColor.1
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        whoIsPayVM.didSelectItem(at: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WhoIsPayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 72 , height: 100)
    }
}

// MARK: - WhoIsPayViewProtocol
extension WhoIsPayViewController: WhoIsPayViewProtocol {
    func prepareView() {
        collectionView.layer.cornerRadius = 30
        collectionView.backgroundColor = .lightGray
        collectionView.register(WhoIsPayCell.self, forCellWithReuseIdentifier: WhoIsPayCell.WhoIsPayIdentifier.custom.rawValue)
        whoIsPayVM.fechtUsers()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
